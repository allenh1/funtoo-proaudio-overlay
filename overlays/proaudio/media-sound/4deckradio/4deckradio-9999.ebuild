# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit autotools-utils git-2

DESCRIPTION="Multi-deck media playback for radio stations"
HOMEPAGE="https://github.com/adiknoth/4deckradio"
EGIT_REPO_URI="git://github.com/adiknoth/${PN}.git"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="-old"

RDEPEND="x11-libs/gtk+:3
	old? ( media-libs/gstreamer:0.10 )
	!old? ( media-libs/gstreamer:1.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	old? ( media-plugins/gst-plugins-jack:0.10 )
	!old? ( media-plugins/gst-plugins-jack:1.0 )"

AUTOTOOLS_AUTORECONF="1"

src_configure() {
	local myeconfargs=( $(use_with old old-gstreamer) )
	autotools-utils_src_configure
}
