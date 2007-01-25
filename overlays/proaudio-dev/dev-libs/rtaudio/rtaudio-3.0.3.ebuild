# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION=" set of C++ classes which provide a common API for realtime audio
input/output across Linux (native ALSA, JACK, and OSS)"
HOMEPAGE="http://www.music.mcgill.ca/~gary/rtaudio"
SRC_URI="http://music.mcgill.ca/~gary/rtaudio/release/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE="jack alsa oss doc debug test"

DEPEND="${RDEPEND}
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_compile() {

	
	econf `use_with jack` \
		`use_with alsa` \
		`use_with oss` \
		`use_enable debug` \
		|| die "config failed"
	use test && emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" || die "install failed"
	use doc && dohtml doc/html/*
	dodoc readme
}
