# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils git-2

DESCRIPTION="Audio player with time stretch and pitch shift"
HOMEPAGE="http://www.teuton.org/~gabriel/stretchplayer/"
EGIT_REPO_URI="git://gitorious.org/stretchplayer/stretchplayer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="media-libs/rubberband
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit"

DEPEND="${RDEPEND}
	dev-util/cmake"

pkg_setup() {
	DOCS="AUTHORS COPYING README.txt"
}

src_configure() {
	local mycmakeargs=""
	if use debug; then
		mycmakeargs+=" -DCMAKE_BUILD_TYPE=Debug"
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cp Documentation/ui-mockup.svg stretchplayer.svg
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/pixmaps
	doins "${S}/stretchplayer.svg"
	make_desktop_entry stretchplayer StretchPlayer /usr/share/pixmaps/stretchplayer.svg AudioVideo
}

pkg_postinst() {
	echo
	elog "Make sure that you use a JACK buffer size larger than 256."
	elog "Less than 256 is known to have real-time issues."
}
