# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils multilib toolchain-funcs

DESCRIPTION="An LV2 audio plugin implementing a powerful and flexible parametric equalizer"
HOMEPAGE="http://eq10q.sourceforge.net/"
MY_P="EQ10Q-LV2Plugin-source-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.20.3:2.4
	>=dev-util/lv2-c++-tools-1.0.3
	>=sci-libs/plotmm-0.1.2"
DEPEND="${RDEPEND}
	>=dev-cpp/pstreams-0.7.0
	virtual/pkgconfig"

S="${WORKDIR}/EQ10Q"

src_prepare() {
	# CXX and LDFLAGS fixes
	epatch "${FILESDIR}/${P}-Makefile.patch"
	# the gentoo dev-cpp/pstreams-0.7.0 package installs the header in
	# /usr/include but source expects it in /usr/include/pstreams
	epatch "${FILESDIR}/${P}-pstreams-header-location.patch"

	# there are hard coded paths to image files in the sources
	sed -i -e "s|/usr/local/lib/|/usr/$(get_libdir)/|g" \
		pixmapcombo.h main_window.cpp || die
}

src_compile() {
	CXX="$(tc-getCXX)" emake || die
}

src_install() {
	einstall INSTALL_DIR="${D}/usr/$(get_libdir)/lv2" || die
	dodoc README
}
