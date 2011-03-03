# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs multilib

DESCRIPTION="A high performance audio signal convolver library"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/libs"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	CXX="$(tc-getCXX)" emake || die
}

src_install() {
	make DESTDIR="${D}" PREFIX=/usr LIBDIR="$(get_libdir)" install || die
	dodoc ../AUTHORS
}
