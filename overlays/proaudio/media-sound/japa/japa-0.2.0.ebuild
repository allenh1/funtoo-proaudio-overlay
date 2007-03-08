# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="JAPA is a perceptual analyzer for JACK and ALSA"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=media-libs/libclalsadrv-1.1.0
	>=media-libs/libclthreads-2.2.0
	>=media-libs/libclxclient-3.3.0
	=sci-libs/fftw-3*
	=media-libs/freetype-2*"

S="${WORKDIR}/${PN}"
src_unpack(){
	unpack "${A}"
	cd ${S}
	sed -i -e 's@g++@$(CXX)@g' \
		-e 's@.*march=pentium4.*@@g' \
		-e '/install\:/'a'XYZ/usr/bin/install -d \$\(DESTDIR\)\$\(PREFIX\)\/bin' \
		-e 's@\(/usr/bin/install -m 755 japa\ \)@\1$(DESTDIR)@g' Makefile
	sed -i -e 's@^XYZ@\t@g' Makefile
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
	newdoc .japarc japarc.example
}
