# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils exteutils

DESCRIPTION="Gmerlin A/V decoder library"
HOMEPAGE="http://gmerlin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cddb cdio doc debug jpeg libvisual musicbrainz nls oss png
pulseaudio quicktime tiff utils v4l"

RDEPEND=">=dev-libs/libxml2-2.4.0
		>=media-libs/gavl-1.4.0
		>=media-libs/fontconfig-2.2.3
		>=media-libs/freetype-2
		>=x11-libs/gtk+-2.8.0
		virtual/opengl
		alsa? ( >=media-libs/alsa-lib-1.0.0 )
		cddb? ( >=media-libs/libcddb-1.0.2 )
		cdio? ( >=dev-libs/libcdio-0.76 )
		jpeg? ( virtual/jpeg )
		libvisual? ( >=media-libs/libvisual-0.4.0 )
		musicbrainz? ( >=media-libs/musicbrainz-2.0.2 )
		png? ( media-libs/libpng )
		pulseaudio? ( media-sound/pulseaudio )
		quicktime? ( >=media-libs/libquicktime-1.0.3 )
		tiff? ( media-libs/tiff )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-cflags.patch"
	"${FILESDIR}/${P}-makefile-am.patch"
)
AUTOTOOLS_AUTORECONF="1"

src_prepare() {
	esed_check -i -e "s:../img/:${S}/doc/img/:" "${S}/doc/${PN}.texi"
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable cddb)
		$(use_enable cdio libcdio)
		$(use_enable debug)
		$(use_with doc doxygen)
		$(use_enable jpeg libjpeg)
		$(use_enable libvisual)
		$(use_enable musicbrainz)
		$(use_enable nls)
		$(use_enable oss)
		$(use_enable png libpng)
		$(use_enable pulseaudio)
		$(use_enable quicktime lqt)
		$(use_enable tiff libtiff)
		$(use_enable v4l)
		$(use_enable utils plugincfg)
		$(use_enable utils alsamixer)
		$(use_enable utils player)
		$(use_enable utils kbd)
		$(use_enable utils transcoder)
		$(use_enable utils visualizer)
		--disable-esd
		--without-cpuflags
		--disable-dependency-tracking
	)
	autotools-utils_src_configure
}
