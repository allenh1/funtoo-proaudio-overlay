# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools-utils

if [ "${PV}" == "9999" ]; then
	inherit bzr
	EBZR_REPO_URI="bzr://bzr.savannah.gnu.org/psychosynth/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://ftp.gnu.org/gnu/psychosynth/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="mirror"
fi

DESCRIPTION="Free software synthesizer inspired by the ideas of the Reactable"
HOMEPAGE="http://www.psychosynth.com/"

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa jack osc oss +psynth3d sndfile static-libs test vorbis xml"

RDEPEND=">=dev-libs/boost-1.39
	>=dev-libs/libsigc++-2.0:2
	>=media-libs/libsoundtouch-1.3.1-r1
	>=x11-libs/gtk+-2:2
	alsa? ( >=media-libs/alsa-lib-1.0.14a-r1 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )
	osc? ( >=media-libs/liblo-0.24 )
	psynth3d? ( >=dev-games/cegui-0.7.7[ogre]
				>=dev-games/ois-1.2.0
				>=dev-games/ogre-1.8.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	vorbis? ( >=media-libs/libvorbis-1.2.0 )
	xml? ( >=dev-libs/libxml2-2.6.31 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1
DOCS=(AUTHORS ChangeLog)

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		$(use_enable alsa)
		$(use_enable jack)
		$(use_enable oss)
		$(use_enable psynth3d)
		$(use_enable sndfile)
		$(use_enable vorbis)
		$(use_enable xml libxml)
		$(use_with test boost-unit-test-framework)
	)
	autotools-utils_src_configure
}
