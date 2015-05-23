# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils

DESCRIPTION="Gmerlin A/V decoder library"
HOMEPAGE="http://gmerlin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN%%-*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="a52 aac cdda debug doc dts dvd ffmpeg flac mad mjpeg mpeg musepack nls
ogg jpeg2k plugins png samba schroedinger speex theora tiff vdpau vorbis X"

RDEPEND=">=media-libs/gavl-1.4.0
		a52? ( media-libs/a52dec )
		aac? ( media-libs/faad2 )
		cdda? ( dev-libs/libcdio )
		dts? ( media-libs/libdca )
		dvd? ( media-libs/libdvdread )
		ffmpeg? ( media-video/ffmpeg )
		flac? ( media-libs/flac )
		jpeg2k? ( media-libs/openjpeg )
		mad? ( media-libs/libmad )
		mjpeg? ( media-video/mjpegtools )
		mpeg? ( media-libs/libmpeg2 )
		nls? ( sys-devel/gettext )
		ogg? ( media-libs/libogg )
		plugins? ( >=media-libs/gmerlin-0.3.8 )
		png? ( media-libs/libpng )
		samba? ( net-fs/samba )
		schroedinger? ( media-libs/schroedinger )
		speex? ( media-libs/speex )
		theora? ( media-libs/libtheora )
		tiff? ( media-libs/tiff )
		vdpau? ( x11-libs/libvdpau )
		vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}/${PN}-cflags.patch" )
AUTOTOOLS_AUTORECONF="1"

src_prepare() {
	# new ffmpeg-API
	sed -i -e 's|->bits_per_sample|->bits_per_coded_sample|g' \
		lib/demux_ffmpeg.c lib/audio_ffmpeg.c lib/video_ffmpeg.c
	# Patch for >=ffmpeg-0.4.9_pre20081003
	if has_version ">=media-video/ffmpeg-0.4.9_pre20081003"; then
		sed -i -e 's|offset_t|int64_t|g' lib/demux_ffmpeg.c
	fi

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable a52 liba52)
		$(use_enable aac faad2)
		$(use_enable cdda libcdio)
		$(use_enable debug)
		$(use_with doc doxygen)
		$(use_enable dts libdca)
		$(use_enable dvd dvdread)
		$(use_enable ffmpeg libavcodec)
		$(use_enable ffmpeg libpostproc)
		$(use_enable ffmpeg libswscale)
		$(use_enable ffmpeg libavformat)
		$(use_enable flac
		$(use_enable jpeg2k openjpeg))
		$(use_enable mad)
		$(use_enable mjpeg mjpegtools)
		$(use_enable mpeg libmpeg2)
		$(use_enable musepack)
		$(use_enable nls)
		$(use_enable ogg)
		$(use_enable plugins gmerlin)
		$(use_enable png libpng)
		$(use_enable samba)
		$(use_enable schroedinger)
		$(use_enable speex)
		$(use_enable theora theoradec)
		$(use_enable tiff libtiff)
		$(use_enable vdpau)
		$(use_enable vorbis)
		$(use_with X x)
		--without-cpuflags
		--disable-dependency-tracking
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		cd "${BUILD_DIR}/doc"
		emake
	fi
}

src_install() {
	autotools-utils_src_install

	if use doc; then
		cd "${BUILD_DIR}/doc"
		emake DESTDIR="${D}" install
	fi
}
