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
	 vorbis? ( media-sound/vorbis-tools )
	 media-sound/alsamixergui
	 virtual/mpg123
	 >=sci-libs/fftw-3"

src_unpack() {
	unpack ${A}
	cd ${S}
	# qt utils path
	sed -i -e "s:^UIC.*:UIC = \${QTDIR}/bin/uic:" defines.gentoo || \
		die "changing uic-dir failed"
	sed -i -e "s:^MOC.*:MOC = \${QTDIR}/bin/moc:" defines.gentoo || \
		die "changing moc-dir failed"
	
	# DEFINE FIX
	sed -i -e "s:^\(CFLAGS.*\):\1 -D QT_THREAD_SUPPORT:" defines.gentoo || \
		die "ADD QT_THREAD_SUPPORT failed"
	
	# gcc4.1 fixes
	sed -i -e "s|MixerDialogLogic::||g" mixerdialog.logic.h || \
	 	die "failed to apply gcc4.1 fix to mixerdialog.logic.h"
	sed -i -e "s|PreferencesLogic::||g" preferences.logic.h || \
		die "failed to apply gcc4.1 fix to preferences.logic.h"
	sed -i -e "s|QSong::||" qsong.h || \
		die "failed to apply gcc4.1 fix to qsong.h"
	sed -i -e "36,37s|SongWithDistance::||" heap.cpp || \
		die "failed to apply gcc4.1 fix to heap.cpp"
	sed -i -e "s|SongPlayerLogic::||g" songplayer.logic.h || \
		die "failed to apply gcc4.1 fix to songplayer.logic.h"

	# fix Makefile
	epatch "${FILESDIR}/Makefile-prefix.patch"
	epatch "${FILESDIR}/Makefile-make_install.patch"
	epatch "${FILESDIR}/Makefile-nostrip.patch"

	sed -i -e "s:^PREFIX.*:PREFIX = /usr:" makefile || \
	        die "changing makefile failed"
	#verbose makefile
	sed -i -e 's:^\t@:\t:g' makefile 
}

src_compile() {
	addwrite "${QTDIR}/etc/settings"

	cp defines.gentoo defines
	make ${MAKEOPTS} CPP=$(tc-getCXX) CC=$(tc-getCC) VARTEXFONTS=${T}/fonts LDFLAGS="${LDFLAGS} `pkg-config --libs fftw3` `pkg-config --libs alsa` -lrt" || die "make failed"
}

src_install () {
#	make is broken (installs into /bpmdj)
	make DESTDIR="${D}" install || die "make install failed"
#	mv ${D}/usr/share/doc/{${PN},${PF}}

	exeinto /usr/bin
	#doexe alsamixerguis bpmdj-raw bpmdj-record bpmdj-replay copydirstruct fetchdirstruct fetchfiles kbpm-batch kbpm-dj kbpm-merge kbpm-mix kbpm-play rbpm-play record_mixer xmms-play || die "doexe failed"
	use mp3 && doexe bpmdj-import-mp3.pl
	use vorbis && doexe bpmdj-import-ogg.pl
	dodoc authors changelog copyright readme todo
	#mkdir -p ${D}/usr/share/bpmdj
	#cp -pPR sequences ${D}/usr/share/bpmdj/ || die "cp failed"
}
