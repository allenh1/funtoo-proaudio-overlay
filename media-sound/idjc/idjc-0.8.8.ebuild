# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit eutils python

RESTRICT="mirror"
DESCRIPTION="Internet DJ Console has two media players, jingles player, crossfader, VoIP and streaming"
HOMEPAGE="http://idjc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

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
	unpack ${A}
}

src_prepare() {
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
#	python_convert_shebangs $(python_get_version) "${D}/usr/bin/idjcctrl"
}
