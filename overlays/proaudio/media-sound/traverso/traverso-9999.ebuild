# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4 cmake-utils cvs

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"

ECVS_SERVER="cvs.savannah.nongnu.org:/sources/traverso"
ECVS_MODULE="traverso"
S="${WORKDIR}/${ECVS_MODULE}"

IUSE="alsa debug jack lv2 mad portaudio opengl"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

RDEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui opengl? ( x11-libs/qt-opengl ) )
			>=x11-libs/qt-4.3:4 )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( =media-libs/portaudio-19* )
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	lv2? ( dev-libs/rasqal dev-libs/redland media-libs/slv2 )
	mad? ( media-libs/libmad )
	lame? ( media-sound/lame )
	opengl? ( virtual/opengl )
	media-libs/libogg
	media-libs/libvorbis
	media-sound/wavpack"
	# Note: wavpack and vorbis are not configurable at this point

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.3"

pkg_setup() {
	if use opengl && ! has_version x11-libs/qt-opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for traverso requires qt4 to be built with opengl support"
	fi
}


src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want lv2 LV2)
		$(cmake-utils_use_want mad MP3_DECODE)
		$(cmake-utils_use_want lame MP3_ENCODE)
		$(cmake-utils_use_want opengl OPENGL)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want portaudio PORTAUDIO)"

	use lv2 && mycmakeargs="${mycmakeargs} -DUSE_SYSTEM_SLV2_LIBRARY=ON"

	CMAKE_IN_SOURCE_BUILD=1
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README resources/help.text

	doicon resources/freedesktop/icons/128x128/apps/${PN}.png
	make_desktop_entry ${PN} Traverso ${PN} "AudioVideo;Audio;"
	cd resources/themes
	for i in */*.xml; do
		insinto "/usr/share/${PN}/themes/$(dirname $i)"
		doins $i
	done
}
