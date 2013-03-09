# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils git

DESCRIPTION="software application/system for real-time, in-performance sequencing, sampling, and looping."
HOMEPAGE="http://gabe.is-a-geek.org/composite/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug ladspa"

RDEPEND="media-libs/rubberband
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	media-libs/flac
	ladspa? ( media-libs/liblrdf )
	dev-libs/boost"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	|| ( ( sys-libs/zlib
			dev-libs/libtar )
		app-arch/libarchive )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog DEVELOPERS.txt README.txt"
}

#	dirty hack, without it build fails about 67%,	 #
#	but I don't know does app works fine with it? %) #
#src_prepare() {
#	sed -e "s/ADD_SUBDIRECTORY(test)//" \
#		 -e "s/ENABLE_TESTING()//" \
#		 -i "${S}/src/Tritium/CMakeLists.txt"
#}

src_configure() {
	local mycmakeargs=""
	if use debug; then
		mycmakeargs+=" -DCMAKE_BUILD_TYPE=Debug"
	fi
	mycmakeargs+=" $(cmake-utils_use_want ladspa LRDF)"

	cmake-utils_src_configure
}
