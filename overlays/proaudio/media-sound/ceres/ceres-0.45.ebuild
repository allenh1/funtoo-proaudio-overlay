# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit virtualx2
RESTRICT="mirror"
DESCRIPTION="A program for displaying sonograms and for sound effects in the frequency domain"
HOMEPAGE="http://ccrma.stanford.edu/~kjetil/src"
SRC_URI="http://ccrma.stanford.edu/~kjetil/src/${P}.tar.gz"

KEYWORDS="x86"
SLOT="0"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=dev-lang/python-1.5.2
	media-libs/libsndfile
	=x11-libs/gtk+-1.2*
	>=dev-libs/libxml-1.8.17
	>=media-libs/libsamplerate-0.1.1"

src_unpack(){
	unpack "${A}"
	cd "${S}"

	# A libglade tar-ball is included in ceres. However,
	# running make inside the doc directory of libglade fails,
	# saying that a program called "libglade-scan" can't open display :0.0
	# This problem is solved by using Xemake. 
	# However, when doing a make install in the doc directory of libglade,
	# the following error occurs: open_wr:
	# /usr/share/ceres/share/gnome/html/libglade
	# Therefore the tarball of libglade is repacked, 
	# where the compilation of the doc directory is removed:
	cd src/packages
	tar xvzf libglade-0.17.tar.gz
	cd libglade-0.17
	sed -ie 's/doc\/Makefile//g' configure
	rm -fr doc/*
	echo "all:" >doc/Makefile
	echo "install:" >>doc/Makefile
	cd ..
	rm libglade-0.17.tar.gz
	tar cvf libglade-0.17.tar libglade-0.17
	gzip libglade-0.17.tar
	cd ../..

	cd src
	# Adding CFLAGS and --fast-math to the compilling options.
	# (--fast-math should be safe to add.)
	sed -ie 's/-O3 -g/$(CFLAGS) --fast-math/' Makefile
	sed -ie 's/INSTALLPATH=\/usr\/testing/INSTALLPATH=\/usr/' Makefile
}

src_compile() {
	cd src
	Xemake -j1 || die "make failed"
}

src_install() {
	cd doc
	dodoc cereshelp.html
	cd ../src
	make INSTALLPATH=${D}/usr X11PATH=${D}/usr/X11R6 DESTDIR=${D} install
}
