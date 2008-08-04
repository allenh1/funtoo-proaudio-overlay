# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils qt4 subversion

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net/"

ESVN_REPO_URI="http://hydrogen-music.org/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack ladspa oss portaudio"

RDEPEND="
	|| ( (
         	x11-libs/qt-core:4
			x11-libs/qt-gui:4 )
			>=x11-libs/qt-4.1:4	)
	dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	media-libs/flac
	dev-libs/libtar
	portaudio? ( =media-libs/portaudio-18.1* )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )"

DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	esed_check -i -e 's|QSvgRenderer|Qt/QSvgRenderer|g' gui/src/widgets/Button.cpp

	# fake config.h
	echo "#define CONFIG_PREFIX \"/usr\"" >> config.h
	echo "#define DATA_PATH \"/usr/share/hydrogen/data\"" >> config.h
}

src_compile() {
	eqmake4 all.pro
	emake -j1 || die "emake failed"
}

src_install() {
	make INSTALL_ROOT="${D}/usr" install || die "make install failed"

	# install tools
	for i in hydrogenSynth hydrogenPlayer; do
		dobin extra/$i/$i
	done

	# desktop entry
	newicon "data/img/gray/icon32.png" "${PN}.png"
	make_desktop_entry "${PN}" "Hydrogen" "${PN}" "AudioVideo;Audio;sequencer"
}
