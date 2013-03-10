# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit autotools eutils python git-2

RESTRICT="mirror"
DESCRIPTION="Internet DJ Console has two media players, jingles player, crossfader, VoIP and streaming"
HOMEPAGE="http://idjc.sourceforge.net/"
EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="aac flac mad vorbis wma"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.7
		dev-python/eyeD3
		dev-python/pygtk
		media-libs/libsamplerate
		media-libs/libsndfile
		media-libs/mutagen
		media-libs/libshout-idjc
		wma? ( media-video/ffmpeg )
		flac? ( media-libs/flac )
		mad? ( media-sound/lame )
		vorbis? ( media-sound/vorbis-tools )
		aac? ( media-libs/faad2 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	cd "${S}/docsrc"
	make && make doc
	cd "${S}"
	eautoreconf

	if has_version ">=media-video/ffmpeg-0.4.9_p20080326"; then
		sed -i \
			-e 's:ffmpeg/avcodec.h:libavcodec/avcodec.h:g' \
			-e 's:ffmpeg/avformat.h:libavformat/avformat.h:g' \
			c/avcodecdecode.* \
			|| die "bad sed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dohtml doc/*
#	python_convert_shebangs $(python_get_version) "${D}/usr/bin/idjcctrl"
}
