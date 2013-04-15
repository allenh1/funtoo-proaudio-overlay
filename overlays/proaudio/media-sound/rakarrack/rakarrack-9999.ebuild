# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils git-2

DESCRIPTION="A richly featured multi-effects processor emulating a uitar effects pedalboard"
HOMEPAGE="http://rakarrack.sourceforge.net/"
EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="altivec jacksession sse sse2"

RDEPEND="x11-libs/fltk:1
	x11-libs/libXpm
	>=media-libs/alsa-lib-0.9
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-sound/alsa-utils-0.9
	>=media-sound/jack-audio-connection-kit-0.100.0"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF="1"

src_configure() {
	local myeconfargs=(
		$(use_enable altivec)
		$(use_enable jacksession jack-session)
		$(use_enable sse)
		$(use_enable sse2)
	)
	autotools-utils_src_configure
}
