# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils multilib toolchain-funcs

DESCRIPTION="LV2 plugin for pitch shifting, vocoding, automatic pitch correction
and harmonization"
HOMEPAGE="http://hyperglitch.com/dev/VocProc"
SRC_URI="http://hyperglitch.com/files/vocproc/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.20.3:2.4
	>=dev-util/lv2-c++-tools-1.0.3
	>=sci-libs/fftw-3.2.2:3.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}.lv2"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	CXX="$(tc-getCXX)" make || die
}

src_install() {
	einstall INSTALL_DIR="${D}/usr/$(get_libdir)/lv2" || die
	dodoc README
}
