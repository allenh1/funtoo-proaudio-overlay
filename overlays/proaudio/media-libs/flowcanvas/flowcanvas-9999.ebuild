# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="FlowCanvas is a canvas widget for dataflow systems"
HOMEPAGE="http://drobilla.net/software/flowcanvas"

ESVN_REPO_URI="http://svn.drobilla.net/lad/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-cpp/gtkmm-2.4
		>=dev-cpp/libgnomecanvasmm-2.6
		dev-libs/boost"
#S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	cd "${S}/${PN}" || die "source for ${PN} not found"
	NOCONFIGURE=1 ./autogen.sh
	econf --enable-anti-aliasing || die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README ChangeLog NEWS
}
