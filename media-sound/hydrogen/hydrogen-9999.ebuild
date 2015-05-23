# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils git-2 cmake-utils

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://www.hydrogen-music.org/"

EGIT_REPO_URI="git://github.com/hydrogen-music/hydrogen.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack jacksession ladspa lash lrdf portaudio portmidi rubberband"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	dev-libs/libtar
	media-libs/rubberband
	dev-qt/qtxmlpatterns
	portaudio? ( >=media-libs/portaudio-18.1 )
	portmidi? ( media-libs/portmidi )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )
	lash? ( virtual/liblash )
	lrdf? ( media-libs/liblrdf )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mycmakeargs=(	${mycmakeargs}
						$(cmake-utils_use_want alsa ALSA)
						$(cmake-utils_use_want debug DEBUG)
						$(cmake-utils_use_want jack JACK)
						$(cmake-utils_use_want jacksession JACKSESSION)
						$(cmake-utils_use_want ladspa LADSPA)
						$(cmake-utils_use_want lash LASH)
						$(cmake-utils_use_want lrdf LRDF)
						$(cmake-utils_use_want portaudio PORTAUDIO)
						$(cmake-utils_use_want portmidi PORTMIDI)
						$(cmake-utils_use_want rubberband RUBBERBAND)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon "${S}/data/img/gray/h2-icon.svg"
}
