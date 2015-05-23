# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit virtualx2
RESTRICT="mirror"
DESCRIPTION="A program for displaying sonograms and doing sound effects in the frequency domain"
HOMEPAGE="http://www.notam02.no/arkiv/src/"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

KEYWORDS="x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=dev-lang/python-1.5.2
	media-libs/libsndfile
	=x11-libs/gtk+-1.2*
	>=dev-libs/libxml-1.8.17
	>=x11-libs/openmotif-2.0.0
	>=media-libs/libsamplerate-0.1.2"

src_unpack(){
	unpack "${A}"
	cd "${S}"

	# A libglade tar-ball is included in ceres. However, running make 
	# inside the doc directory of libglade fails,
	# saying that a program called "libglade-scan" can't open display :0.0
	# This problem is solved by using Xemake. However, when doing a 
	# make install in the doc directory of libglade,
	# the following error occurs: 
	# open_wr:	/usr/share/ceres/share/gnome/html/libglade
	# Therefore the tarball of libglade is repacked, where the compilation
	# of the doc directory is removed:
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
	sed -i -e 's@\(^ADDITIONALCFLAGS=\).*\(-I\$\)@\1$(CFLAGS) --fast-math \2@' \
		-e 's@\(^INSTALLPATH=\).*@\1/usr@g' \
		-e 's@\(^GCC=.*\)@\1 -fPIC@g' \
		-e 's@$(X11PATH)/lib/X11/@$(X11PATH)/share/X11/@g' Makefile
}

src_compile() {
	cd src
	Xemake -j1 || die "make failed"
}

src_install() {
	cd doc
	dohtml cereshelp.html
	cd ../src
	emake INSTALLPATH="${D}/usr" X11PATH="${D}/usr" DESTDIR="${D}" install \
		|| die "install failed"
}
