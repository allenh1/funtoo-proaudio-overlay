# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs multilib

RESTRICT="mirror"
DESCRIPTION="The JACK and ALSA Audio Analyser is an audio signal generator and spectrum analyser"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.2
	>=sci-libs/fftw-3.0.0
	>=x11-libs/gtk+-2.0.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	esed_check -i -e 's@g++@\$(CXX) \$(LDFLAGS)@g' -e '/^CPPFLAGS/ s/-O2//' Makefile
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die "emake failed"
}

src_install() {
	dobin jaaa || die "dobin failed"
	dodoc AUTHORS README
}
