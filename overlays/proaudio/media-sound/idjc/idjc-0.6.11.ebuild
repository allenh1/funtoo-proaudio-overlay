# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="mirror"
DESCRIPTION="Internet DJ Console"
HOMEPAGE="http://www.onlymeok.nildram.co.uk"
SRC_URI="http://www.onlymeok.nildram.co.uk/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="aac flac mad vorbis"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.7
		dev-python/eyeD3
		dev-python/pygtk
		media-libs/libsamplerate
		media-libs/libsndfile
		>=media-libs/libshout-2.1
		media-libs/xine-lib
		flac? ( media-libs/flac )
		mad? ( media-sound/lame )
		vorbis? ( media-sound/vorbis-tools )
		aac? ( media-libs/faad2 )"
DEPEND="${RDEPEND}"

src_compile() {
	cd "${S}"
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
}
