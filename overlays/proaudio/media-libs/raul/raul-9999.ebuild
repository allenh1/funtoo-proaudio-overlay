# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion

RESTRICT="nomirror"
IUSE="debug doc"
DESCRIPTION="Realtime Audio Utility Library: lightweight header-only C++"
HOMEPAGE="http://wiki.drobilla.net/Raul"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=">=dev-util/pkgconfig-0.9.0
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.14
	dev-libs/boost
	dev-libs/redland
	>=dev-cpp/glibmm-2.4
	doc? ( app-doc/doxygen )
	=dev-libs/redlandmm-9999"

src_compile() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	
	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"
	
	./waf configure ${myconf} || die "configure failed"
	./waf build ${MAKEOPTS} || die "waf failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog
}
