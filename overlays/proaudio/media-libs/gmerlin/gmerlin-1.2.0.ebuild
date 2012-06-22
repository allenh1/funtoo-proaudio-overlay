# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Gmerlin A/V decoder library"
HOMEPAGE="http://gmerlin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cddb cdio doc debug esd jpeg libvisual mjpeg musicbrainz nls oss png
pulseaudio quicktime tiff utils v4l"

DEPEND=">=dev-libs/libxml2-2.4.0
		>=media-libs/gavl-1.4.0
		>=media-libs/fontconfig-2.2.3
		>=media-libs/freetype-2
		>=x11-libs/gtk+-2.8.0
		virtual/opengl
		alsa? ( >=media-libs/alsa-lib-1.0.0 )
		cddb? ( >=media-libs/libcddb-1.0.2 )
		cdio? ( >=dev-libs/libcdio-0.76 )
		doc? ( app-doc/doxygen )
		esd? ( >=media-sound/esound-0.2.19 )
		jpeg? ( virtual/jpeg )
		libvisual? ( >=media-libs/libvisual-0.4.0 )
		mjpeg? ( media-video/mjpegtools )
		musicbrainz? ( >=media-libs/musicbrainz-2.0.2 )
		png? ( media-libs/libpng )
		pulseaudio? ( media-sound/pulseaudio )
		quicktime? ( >=media-libs/libquicktime-1.0.3 )
		tiff? ( media-libs/tiff )
		"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-cflags.patch
	eautoreconf
}

src_compile() {
	econf \
		--without-cpuflags \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF}/html \
		$(use_enable alsa) \
		$(use_enable cddb) \
		$(use_enable cdio libcdio) \
		$(use_enable debug) \
		$(use_with doc doxygen) \
		$(use_with doc texinfo) \
		$(use_enable esd) \
		$(use_enable jpeg libjpeg) \
		$(use_enable libvisual) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable musicbrainz) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable png libpng) \
		$(use_enable pulseaudio) \
		$(use_enable quicktime lqt) \
		$(use_enable tiff libtiff) \
		$(use_enable v4l) \
		$(use_enable utils camelot) \
		$(use_enable utils plugincfg) \
		$(use_enable utils alsamixer) \
		$(use_enable utils player) \
		$(use_enable utils kbd) \
		$(use_enable utils transcoder) \
		$(use_enable utils visualizer) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS README INSTALL
}
