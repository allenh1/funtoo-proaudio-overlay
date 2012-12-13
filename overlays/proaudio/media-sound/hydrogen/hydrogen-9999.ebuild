# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils qt4-r2 subversion cmake-utils

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net/"

ESVN_REPO_URI="http://svn.assembla.com/svn/hydrogen/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack jacksession ladspa lash lrdf portaudio portmidi rubberband"

RDEPEND="
	|| ( (
			x11-libs/qt-core:4
			x11-libs/qt-gui:4 )
			>=x11-libs/qt-4.4:4	)
	dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	dev-libs/libtar
	media-libs/rubberband
	x11-libs/qt-xmlpatterns
	portaudio? ( >=media-libs/portaudio-18.1 )
	portmidi? ( media-libs/portmidi )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )
	lash? ( virtual/liblash )
	lrdf? ( media-libs/liblrdf )"

DEPEND="${RDEPEND}"

src_configure() {
	mkdir build
	cd build
	cmake -L \
		-DCMAKE_INSTALL_PREFIX="${ROOT}"/usr DESTDIR="${D}" \
		$(cmake-utils_use_want alsa ALSA) \
		$(cmake-utils_use_want debug DEBUG) \
		$(cmake-utils_use_want jack JACK) \
		$(cmake-utils_use_want jacksession JACKSESSION) \
		$(cmake-utils_use_want ladspa LADSPA) \
		$(cmake-utils_use_want lash LASH) \
		$(cmake-utils_use_want lrdf LRDF) \
		$(cmake-utils_use_want portaudio PORTAUDIO) \
		$(cmake-utils_use_want portmidi PORTMIDI) \
		$(cmake-utils_use_want rubberband RUBBERBAND) .. || die "Compilation failed"
}

src_compile() {
	cd "${S}"/build
	emake
}

src_install() {
	cd "${S}"/build
	emake DESTDIR="${D}" install
	cd ..
	dodoc AUTHORS ChangeLog DEVELOPERS README.txt
}
