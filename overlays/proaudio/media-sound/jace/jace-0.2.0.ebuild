# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

RESTRICT="mirror"
IUSE=""
DESCRIPTION="JACE is a Convolution Engine for JACK and ALSA"
HOMEPAGE="http://www.audiodef.com/gentoo/proaudio/"
SRC_URI="http://www.audiodef.com/gentoo/proaudio/src/jace/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=media-libs/libclalsadrv-1.1.0
	>=media-libs/libclthreads-2.2.1
	=sci-libs/fftw-3*"

S="${WORKDIR}/${PN}"
src_unpack(){
	unpack "${A}"
	cd ${S}
	esed_check -i -e 's@g++@$(CXX)@g' \
		-e 's@^PREFIX.*@PREFIX = /usr@g' \
		-e '/install\:/'a'\	/usr/bin/install -d \$\(DESTDIR\)\$\(PREFIX\)\/bin' \
		-e 's@\(/usr/bin/install -m 755 jace\ \)@\1$(DESTDIR)@g' Makefile
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README README.CONFIG
}
