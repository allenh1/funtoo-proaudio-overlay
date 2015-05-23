# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="mirror"
IUSE=""
DESCRIPTION="JACE is a Convolution Engine for JACK and ALSA"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=media-libs/libclalsadrv-1.0.3
	>=media-libs/libclthreads-2.0.1
	=sci-libs/fftw-3*"

src_unpack(){
	unpack "${A}"
	cd ${S}
	epatch "${FILESDIR}/Makefile-destdir.patch"
	#sed -e "s:^PREFIX.*:PREFIX = /usr:" -i Makefile || die "changing prefix failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README README.CONFIG
}
