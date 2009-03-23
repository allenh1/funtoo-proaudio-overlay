# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI=1

inherit cmake-utils eutils subversion 

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"

ESVN_REPO_URI="https://rosegarden.svn.sourceforge.net/svnroot/rosegarden/branches/qt4"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa jack dssi lirc debug lilypond export kde gnome"

RDEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui )
				>=x11-libs/qt-4.3.0:4 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	lilypond? ( media-sound/lilypond
		|| ( kde? ( kde-base/kghostview ) gnome? ( app-text/evince ) app-text/ggv ) )
	export? ( || ( kde-base/kdialog kde-base/kdebase )
			dev-perl/XML-Twig
			media-libs/libsndfile )
	jack? ( >=media-sound/jack-audio-connection-kit-0.77 )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	dssi? ( >=media-libs/dssi-0.4 )
	lirc? ( >=app-misc/lirc-0.7 )
	|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/liblrdf-0.3
	>=sci-libs/fftw-3.0.0
	>=media-libs/liblo-0.7
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=dev-util/cmake-2.4.2"

LANGS="ca cs cy de en_GB en es et fr it ja nl ru sv zh_CN"

pkg_setup(){
	if ! use alsa  && use jack ;then
		eerror "If you disable alsa jack-support will also be disabled."
		eerror "This is not what you want --> enable alsa useflag" && die
	fi
}

src_compile() {
	# hacks
	sed -i -e 's:meinproc:meinproc4:g' cmake_admin/FindMEINPROC.cmake || die
	sed -i -s '/KLedButton/d' src/GUIFileList.txt || die
	rcc data/data.qrc > data/data.cpp
	# use our own here
	rm -f cmake_admin/FindQt4.cmake

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want debug FULLDBG)
		$(cmake-utils_use_want alsa SOUND)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want dssi DSSI)
		$(cmake-utils_use_want lirc LIRC)
		"

	use debug && CFLAGS="${CFLAGS} -ggdb3"

	cmake-utils_src_compile	
}

DOCS="ChangeLog-svn AUTHORS README TRANSLATORS"
