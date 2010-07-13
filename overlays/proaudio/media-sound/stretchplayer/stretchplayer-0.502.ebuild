# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="Audio player with time stretch and pitch shift"
HOMEPAGE="http://www.teuton.org/~gabriel/stretchplayer/"
SRC_URI="http://www.teuton.org/~gabriel/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RESTRICT="mirror"

RDEPEND="media-libs/rubberband
	>=x11-libs/qt-core-4.5:4
	>=x11-libs/qt-gui-4.5:4
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit"

DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/${PN}"

pkg_setup() {
	DOCS="AUTHORS BUGS.txt ChangeLog README.txt"
}

src_configure() {
	local mycmakeargs=""
	if use debug; then
		mycmakeargs+=" -DCMAKE_BUILD_TYPE=Debug"
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	echo
	elog "Make sure that you use a JACK buffer size larger than 256."
	elog "Less than 256 is known to have real-time issues."
}
