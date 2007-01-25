# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

RESTRICT="nomirror"  # this is because our packages are not on the gentoo mirrors
DESCRIPTION="A program for doing sound effects using one gigantic fft analysis (no windows)."
HOMEPAGE="http://ccrma.stanford.edu/~kjetil/src"
SRC_URI="http://ccrma.stanford.edu/~kjetil/src/${P}.tar.bz2"

KEYWORDS="x86"
SLOT="0"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=dev-lang/python-1.5
	media-libs/libsndfile
	=x11-libs/gtk+-1.2*
	>=dev-libs/libxml-1.8.17
	>=media-libs/libsamplerate-0.1.1
	>=media-sound/ceres-0.45"

src_unpack(){
	unpack "${A}"
	cd "${S}"
	cd src/packages
	tar xzf sndlib.tar.gz
	sed -ie 's/-shared/-shared  -ljack -lsamplerate/' "${S}"/src/Makefile || die "sed failed"
}

src_compile() {
	# Compilation of sndlib.a inside Mammut's makefile fails, so we have to do it manually:
	cd src/packages/sndlib
	econf configure --with-jack --without-guile || die "config failed"	
	$(tc-getCC) -I. -O2 headers.c audio.c io.c sound.c xen.c vct.c clm.c sndlib2xen.c clm2xen.c midi.c -c
	$(tc-getAR) rus sndlib.a headers.o audio.o io.o sound.o xen.o vct.o clm.o sndlib2xen.o clm2xen.o midi.o
	
	cd ../..
	make INSTALLPATH=/usr PYGTK1PATH=/usr/share/ceres || die "make failed"
}

src_install() {
	cd doc
	dodoc mammuthelp.html
	cd ../src
	make INSTALLPATH=${D}/usr X11PATH=${D}/usr/X11R6 PYGTK1PATH=/usr/share/ceres    install || die "install failed" 
}
