# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion

RESTRICT="mirror"
IUSE="debug"
DESCRIPTION="An STL-style C++ wrapper for the Redland RDF Toolkit (librdf)"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
RDEPEND="dev-libs/redland
	dev-libs/boost
	>=dev-cpp/glibmm-2.4"
DEPEND=">=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	local myconf="--prefix=/usr"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die

	./waf build ${MAKEOPTS} || die
}

src_install() {
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README
}
