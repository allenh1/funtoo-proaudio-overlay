# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils multilib toolchain-funcs

RESTRICT="mirror"
#S="${WORKDIR}/${PN}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.audiodef.com/gentoo/proaudio/src/zita-convolver/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="=sci-libs/fftw-3*"

src_unpack() {
	unpack ${A}
	cd ${S}/libs
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	cd ${S}/libs
	emake || die "emake failed"
}

src_install() {
	cd ${S}/libs
	make ZITA-CONVOLVER_LIBDIR="/usr/$(get_libdir)" DESTDIR="${D}" install || die "make install failed"
}
