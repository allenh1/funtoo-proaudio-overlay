# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils cvs

DESCRIPTION="Free Music Instrument Tuner"
HOMEPAGE="http://home.gna.org/fmit/"
ECVS_SERVER="cvs.gna.org:/cvs/fmit"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack oss portaudio"

DEPEND=">=media-libs/freeglut-2.6.0
	>=sci-libs/fftw-3.2.2:3.0
	>=dev-qt/qtcore-4.6.3:4
	>=dev-qt/qtgui-4.6.3:4
	>=dev-qt/qtopengl-4.6.3:4
	alsa? ( >=media-libs/alsa-lib-1.0.23 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.118.0 )
	portaudio? ( media-libs/portaudio )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

DOCS=(ChangeLog README.txt TODO)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use alsa SOUNDSYSTEM_USE_ALSA)
		$(cmake-utils_use jack SOUNDSYSTEM_USE_JACK)
		$(cmake-utils_use oss SOUNDSYSTEM_USE_OSS)
		$(cmake-utils_use portaudio SOUNDSYSTEM_USE_PORTAUDIO)
	)

	cmake-utils_src_configure
}
