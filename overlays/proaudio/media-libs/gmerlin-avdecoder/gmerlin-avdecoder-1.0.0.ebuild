# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Gmerlin A/V decoder library"
HOMEPAGE="http://gmerlin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN%%-*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="a52 aac cdio debug doc dts ffmpeg flac mad mjpeg mpeg musepack nls plugins png samba speex theora tiff vorbis"

DEPEND=">=media-libs/gavl-1.1.0
		a52? ( media-libs/a52dec )
		aac? ( media-libs/faad2 )
		cdio? ( dev-libs/libcdio )
		doc? ( app-doc/doxygen )
		dts? ( media-libs/libdca )
		dvd? ( media-libs/libdvdread )
		ffmpeg? ( media-video/ffmpeg )
		flac? ( media-libs/flac )
		mad? ( media-libs/libmad )
		mjpeg? ( media-video/mjpegtools )
		mpeg? ( media-libs/libmpeg2 )
		musepack? ( media-libs/libmpcdec )
		plugins? ( >=media-libs/gmerlin-0.3.8 )
		png? ( media-libs/libpng )
		samba? ( net-fs/samba )
		speex? ( media-libs/speex )
		theora? ( media-libs/libtheora )
		tiff? ( media-libs/tiff )
		vorbis? ( media-libs/libvorbis )
		"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# new ffmpeg-API
	sed -i -e 's|->bits_per_sample|->bits_per_coded_sample|g' \
		lib/demux_ffmpeg.c lib/audio_ffmpeg.c lib/video_ffmpeg.c
	# Patch for >=ffmpeg-0.4.9_pre20081003
	if has_version ">=media-video/ffmpeg-0.4.9_pre20081003"; then
		sed -i -e 's|offset_t|int64_t|g' lib/demux_ffmpeg.c
	fi

	epatch "${FILESDIR}"/${PN}-cflags.patch
	eautoreconf
}

src_compile() {
	econf \
		--without-cpuflags \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF}/html \
		$(use_enable a52 liba52) \
		$(use_enable aac faad2) \
		$(use_enable cdio libcdio) \
		$(use_enable debug) \
		$(use_with doc doxygen) \
		$(use_enable dts libdca) \
		$(use_enable dvd dvdread) \
		$(use_enable ffmpeg libavcodec) \
		$(use_enable ffmpeg libpostproc) \
		$(use_enable ffmpeg libswscale) \
		$(use_enable ffmpeg libavformat) \
		$(use_enable flac) \
		$(use_enable mad) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable musepack) \
		$(use_enable plugins gmerlin) \
		$(use_enable png libpng) \
		$(use_enable samba) \
		$(use_enable speex) \
		$(use_enable theora) \
		$(use_enable tiff libtiff) \
		$(use_enable vorbis) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS README INSTALL
}
