# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 subversion

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net/"

ESVN_REPO_URI="http://devel.hydrogen-music.org/svn/hydrogen/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack ladspa oss portaudio"

RDEPEND="dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	media-libs/flac
	$(qt4_min_version 4.1.0)
	dev-libs/libtar
	portaudio? ( =media-libs/portaudio-18.1* )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )"

DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.patch"
	sed -i -e 's|QSvgRenderer|Qt/QSvgRenderer|g' gui/src/widgets/Button.cpp
}

src_compile() {
	# maybe let's remove that patch ^^ and use 'qmake all.pro prefix=/usr' in
	# future
	unset QTDIR
	./configure	
	make || die "Failed making hydrogen!"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	
	# install tools
	dobin hydrogenSynth hydrogenPlayer
	
	# desktop entry
	newicon "data/img/gray/icon32.png" "${PN}.png"
	make_desktop_entry "${PN}" "Hydrogen" "${PN}" "AudioVideo;Audio;sequencer"
}
