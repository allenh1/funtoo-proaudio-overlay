# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils subversion

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

ESVN_REPO_URI="https://lmms.svn.sourceforge.net/svnroot/lmms/trunk/lmms"

LICENSE="GPL-2 LGPL"
SLOT="0"
KEYWORDS=""

IUSE="alsa debug fftw fluidsynth jack ogg pulseaudio sdl stk vst"

RDEPEND="|| ( (
				x11-libs/qt-core
				x11-libs/qt-gui[accessibility]
			) >=x11-libs/qt-4.3.0:4[accessibility] )
	alsa? ( media-libs/alsa-lib )
	fftw? ( =sci-libs/fftw-3* )
	fluidsynth? ( media-sound/fluidsynth )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	ogg? ( media-libs/libvorbis 
				media-libs/libogg )
	pulseaudio? ( media-sound/pulseaudio )
	>=media-libs/libsndfile-1.0.11
	media-libs/libsamplerate
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	stk? ( media-libs/stk )
	vst? ( app-emulation/wine )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.5"

DOCS="README AUTHORS ChangeLog TODO"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWANT_SYSTEM_SR=TRUE
		-DWANT_CAPS=TRUE
		-DWANT_TAP=TRUE
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want fftw FFTW3F)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want ogg OGGVORBIS)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want sdl SDL)
		$(cmake-utils_use_want fluidsynth SF2)
		$(cmake-utils_use_want stk STK)
		$(cmake-utils_use_want vst VST)"

	cmake-utils_src_configure
}
