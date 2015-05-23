# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

CMAKE_IN_SOURCE_BUILD="1"

inherit eutils qt4-r2 cmake-utils git-2

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"

EGIT_REPO_URI="git://git.savannah.nongnu.org/${PN}.git"

IUSE="alsa debug jack lame lv2 mad opengl pch portaudio pulseaudio"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

RDEPEND=">=media-libs/libsndfile-1.0.12
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/libvorbis
	media-sound/wavpack
	sci-libs/fftw:3.0
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	lame? ( media-sound/lame )
	lv2? ( dev-libs/rasqal
		dev-libs/redland
		media-libs/slv2 )
	mad? ( media-libs/libmad )
	opengl? ( virtual/opengl
		dev-qt/qtopengl )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )"
	# Note: wavpack and vorbis are not configurable at this point

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.6"

src_configure() {
	local mycmakeargs+="
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want lv2 LV2)
		$(cmake-utils_use_want mad MP3_DECODE)
		$(cmake-utils_use_want lame MP3_ENCODE)
		$(cmake-utils_use_want pch PCH)
		$(cmake-utils_use_want opengl OPENGL)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want portaudio PORTAUDIO)"

	use lv2 && mycmakeargs+=" -DUSE_SYSTEM_SLV2_LIBRARY=ON"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog HISTORY README resources/help.text
	doicon "resources/freedesktop/icons/128x128/apps/${PN}.png"
	domenu resources/traverso.desktop
	insinto "/usr/share/${PN}"
	doins -r resources/themes
}
