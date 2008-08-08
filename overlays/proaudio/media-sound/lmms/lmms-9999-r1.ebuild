# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils cmake-utils subversion

MY_P="${P/_/-}"

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

ESVN_REPO_URI="https://lmms.svn.sourceforge.net/svnroot/lmms/trunk/lmms"

LICENSE="GPL-2 LGPL"
SLOT="0"
KEYWORDS=""

IUSE="alsa debug fftw jack ladspa ogg pch pulseaudio samplerate sdl stk vst"

RDEPEND="|| ( (
				x11-libs/qt-core
				x11-libs/qt-gui
			) >=x11-libs/qt-4.3.0 )
	alsa? ( media-libs/alsa-lib )
	fftw? ( =sci-libs/fftw-3* )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	ladspa? ( media-libs/ladspa-sdk )
	ogg? ( media-libs/libvorbis 
				media-libs/libogg )
	pulseaudio? ( media-sound/pulseaudio )
	samplerate? ( media-libs/libsamplerate )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	stk? ( media-libs/stk )
	vst? ( app-emulation/wine )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.5"

S="${WORKDIR}/${MY_P}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want ladspa CAPS)
		$(cmake-utils_use_want ladspa TAP)
		$(cmake-utils_use_want fftw FFTW3F)
		$(cmake-utils_use_want fftw JACK)
		$(cmake-utils_use_want ogg OGGVORBIS)
		$(cmake-utils_use_want sdl SDL)
		$(cmake-utils_use_want stk STK)
		$(cmake-utils_use_want samplerate SYSTEM_SR)
		$(cmake-utils_use_want vst VST)
		$(cmake-utils_use_want pch PCH)"

	cmake-utils_src_compile -j1
}

src_install() {
	DOCS="README AUTHORS ChangeLog TODO"
	cmake-utils_src_install
}
