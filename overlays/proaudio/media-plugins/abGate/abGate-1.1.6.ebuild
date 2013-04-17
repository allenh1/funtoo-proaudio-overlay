# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qt4-r2 base toolchain-funcs multilib

DESCRIPTION="LV2 Noise Gate plugin"
HOMEPAGE="http://abgate.sourceforge.net/"
SRC_URI="mirror://sourceforge/abgate/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	|| ( media-libs/lv2 media-libs/lv2core )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(README ChangeLog)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch)

src_configure() {
	cd abGateQt
	eqmake4 abGateQt.pro
}

src_compile() {
	base_src_make CXX="$(tc-getCXX)"
}

src_install() {
	base_src_install INSTALL_DIR="${ED}"/usr/$(get_libdir)/lv2
}
