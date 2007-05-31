# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="libraries that provide support for the Resource Description Framework (RDF)"
HOMEPAGE="http://librdf.org/"
SRC_URI="http://download.librdf.org/source/redland-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="mysql sqlite ssl berkdb postgresql"

DEPEND="mysql? ( >=dev-db/mysql-3.23.58 )
	sqlite? ( >=dev-db/sqlite-2.8.16 )
	postgresql? ( dev-db/postgresql )
	ssl? ( >=dev-libs/openssl-0.9.7l )
	berkdb? ( >=sys-libs/db-2.4.14 )
	>=media-libs/raptor-1.4.15
	>=dev-libs/rasqal-0.9.14"
RDEPEND="${DEPEND}"

S="${WORKDIR}/redland-${PV}"

src_compile() {
	# no ebuild for --with-threestore AKT project 3store triple store 
	econf \
		$(use_with mysql) \
		$(use_with sqlite) \
		$(use_with postgresql) \
		$(use_with ssl openssl-digests) \
		$(use_with berkdb bdb ) \
		--with-rasqal=system --with-raptor=system || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	make DESTDIR="${D}" install || die "install failed"
	dohtml README.html
}
