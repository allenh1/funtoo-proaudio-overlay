# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="mp3 vorbis"

inherit eutils toolchain-funcs kde-functions
need-qt 3

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.source.tgz"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 2.6-2.7 - kbpm-play: common.cpp:42: void common_init(): Assertion `sizeof(signed4)==4' failed. - eradicator
KEYWORDS="-amd64 x86 ~ppc"

DEPEND="=x11-libs/qt-3*"

RDEPEND="${DEPEND}
	 mp3? ( dev-perl/MP3-Tag )
	 media-libs/alsa-lib
	 vorbis? ( media-sound/vorbis-tools )
	  || ( media-sound/lame media-sound/bladeenc )
	 media-sound/alsamixergui
	 virtual/mpg123
	 >=sci-libs/fftw-3"

src_unpack() {
	unpack ${A}
	cd ${S}
	# ################ defines.gentoo #############
	# qt utils path
	sed -i -e "s:^UIC.*:UIC = \${QTDIR}/bin/uic:" defines.gentoo || \
		die "changing uic-dir failed"
	sed -i -e "s:^MOC.*:MOC = \${QTDIR}/bin/moc:" defines.gentoo || \
		die "changing moc-dir failed"
	# set qt3 include dir
	sed -i -e 's@\(QT_INCLUDE_PATH=\)\(.*\)@\1-I/usr/qt/3/include/@g' defines.gentoo
	sed -i -e 's@\(QT_INCLUDE_PATH=\)\(.*\)@\1-I/usr/qt/3/include/@g' Data/defines
	# add ldflags to defines.gentoo
	LD_alsa="`pkg-config --libs alsa`" || die "could not find alsa-lib"
	LD_fftw3="`pkg-config --libs fftw3`" || die "could not find fftw libs"
	sed -i -e "s@^LDFLAGS.*@LDFLAGS += $LD_alsa $LD_fftw3 -lrt@g" defines.gentoo
	
	# ################ makefile #############
	# fix Makefile
	epatch "${FILESDIR}/Makefile-make_install.patch"
	# fix odd missing bladenc error (try with lame if bladenc is not installed)
	sed -i -e 's@\(\@bladeenc.*\)@type bladeenc 2>/dev/null \&\& \1 |\| lame $< 	noise.mp3@g' 2>/dev/null makefile
	# verbose Makefile
	sed -i -e 's:^\t@:\t:g' makefile  Data/makefile
	# define Q_OS_LINUX
	sed  -i -e'/#ifdef Q_OS_LINUX/'i"#define Q_OS_LINUX" Data/data.h
	# fix qstring.h path
	for i in `grep -l -Ri \<qstring.h\> *`;do 
		einfo "qstring.h include dir changed in $i"
		sed -i -e "s@<qstring.h>@\"${QTDIR}/include/qstring.h\"@g" $i
	done
}

src_compile() {
	addwrite "${QTDIR}/etc/settings"
	cp defines.gentoo defines

	emake  VARTEXFONTS=${T}/fonts
	#${MAKEOPTS}
}

src_install () {
	make PREFIX="/usr" DESTDIR="${D}" install || die "make install failed"
	exeinto /usr/bin
	use mp3 && doexe bpmdj-import-mp3.pl
	use vorbis && doexe bpmdj-import-ogg.pl
	dodoc authors changelog copyright readme todo
}

