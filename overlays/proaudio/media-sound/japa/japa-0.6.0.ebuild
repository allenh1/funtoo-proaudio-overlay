# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs multilib

RESTRICT="mirror"
IUSE=""
DESCRIPTION="JAPA is a perceptual analyzer for JACK and ALSA"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.6.1
	=sci-libs/fftw-3*
	=media-libs/freetype-2*"

src_unpack(){
	unpack ${A}
	cd "${S}"
	# fixup vars
	esed_check -i -e 's@g++@$(CXX)@g' \
		-e '/^CPPFLAGS/ s/-O2//' Makefile
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="/usr/" LIBDIR="$(get_libdir)" || die "make failed"
}

src_install() {
	emake PREFIX="/usr/" DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
	insinto /etc/
	insopts -m 0644
	newins .japarc japa.conf
}
