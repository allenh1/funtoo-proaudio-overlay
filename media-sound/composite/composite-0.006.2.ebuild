# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils flag-o-matic toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="software application/system for real-time, in-performance sequencing, sampling, and looping."
HOMEPAGE="http://gabe.is-a-geek.org/composite/"
SRC_URI="http://gabe.is-a-geek.org/composite/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
	dev-util/cmake
	|| ( ( sys-libs/zlib
			dev-libs/libtar )
		app-arch/libarchive )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog DEVELOPERS.txt README.txt"
}

src_configure() {
	local mycmakeargs=""
	if use debug; then
		mycmakeargs+=" -DCMAKE_BUILD_TYPE=Debug"
	fi

	mycmakeargs+="$(cmake-utils_use_want ladspa LRDF)"
	if use ladspa ; then
		append-cppflags "$($(tc-getPKG_CONFIG) lrdf --cflags)"
	fi

	cmake-utils_src_configure
}
