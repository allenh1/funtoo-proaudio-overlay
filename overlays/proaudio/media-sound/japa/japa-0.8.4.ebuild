# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib toolchain-funcs

RESTRICT="mirror"
IUSE=""
DESCRIPTION="JAPA is a perceptual analyzer for JACK and ALSA"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/alsa-lib
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.6.1
	media-libs/zita-alsa-pcmi
	media-sound/jack-audio-connection-kit
	sci-libs/fftw:3.0
	x11-libs/libX11
	x11-libs/libXft"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/g++/$(CXX)/g' -e 's/-O2//g' source/Makefile
}

src_compile() {
	tc-export CXX
	emake -C source PREFIX="${EPREFIX}/usr/" LIBDIR="$(get_libdir)"
}

src_install() {
	emake -C source PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	dodoc AUTHORS README
}
