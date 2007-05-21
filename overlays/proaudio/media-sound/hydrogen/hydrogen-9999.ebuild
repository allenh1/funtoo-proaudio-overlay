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
	$(qt4_min_version 4)
	portaudio? ( =media-libs/portaudio-18.1* )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )"

DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.patch"
}

src_compile() {

	export PORTAUDIOPATH="${ROOT}usr"
	unset QTDIR

	./configure
	emake || die "Failed making hydrogen!"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	# fix fdo category
	sed -i -e "s/AudioVideo;Sound;Audio;Qt;/Qt;AudioVideo;Audio;Sequencer;/" \
		"${D}/usr/share/applications/${PN}.desktop"
}
