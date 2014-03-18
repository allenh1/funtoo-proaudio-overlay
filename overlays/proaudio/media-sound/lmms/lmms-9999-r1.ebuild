# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-2

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

EGIT_REPO_URI="https://github.com/LMMS/${PN}.git"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""

IUSE="alsa debug fftw fluidsynth jack ogg pulseaudio sdl stk vst"

RDEPEND="dev-qt/qtcore
	dev-qt/qtgui[accessibility]
	media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.11
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0 )
	fluidsynth? ( media-sound/fluidsynth )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	ogg? ( media-libs/libvorbis
		media-libs/libogg )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	stk? ( media-libs/stk )
	vst? ( app-emulation/wine )"
DEPEND="${RDEPEND}"

DOCS=( README AUTHORS ChangeLog.old TODO )

src_configure() {
	mycmakeargs=(
		-DWANT_SYSTEM_SR=TRUE
		-DWANT_CAPS=TRUE
		-DWANT_TAP=TRUE
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want fftw FFTW3F)
		$(cmake-utils_use_want fluidsynth SF2)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want ogg OGGVORBIS)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want sdl SDL)
		$(cmake-utils_use_want stk STK)
		$(cmake-utils_use_want vst VST)
	)

	cmake-utils_src_configure
}
