# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic exteutils
RESTRICT="nomirror"

DESCRIPTION="Open Movie Editor is designed to be a simple tool, that provides basic movie making capabilites."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://openmovieeditor.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="ffmpeg"
DEPEND=">=media-libs/libquicktime-1.0.2
		x11-libs/fltk
		>=dev-libs/glib-2.10.3
		>=media-libs/portaudio-19_pre
		media-libs/mesa
		ffmpeg? ( media-video/ffmpeg )
		>=media-libs/gavl-1.0.0
		media-sound/jack-audio-connection-kit
		media-libs/libsndfile
		>=media-libs/libsamplerate-0.1.1
		>=media-libs/libsndfile-1.0.0"
RDEPEND="${DEPEND}
	media-plugins/frei0r-plugins" # no real run-dep, but otherwise no plugins

src_unpack(){
	unpack ${A}
	cd "${S}"
	# newer ffmepg version api changes
	local incl="${ROOT}/usr/include/libavcodec/avcodec.h"
	if grep -q 'avcodec_decode_audio2' "$incl" ;then
		esed_check -i -e 's@\(avcodec_decode_audio\)(@\12(@g' \
			src/AudioFileFfmpeg.cxx
	fi
}

src_compile(){
	# workaround for newer ffmpeg
	CPPFLAGS="${CPPFLAGS} -D__STDC_CONSTANT_MACROS" \
		econf || die "econf failed"
	append-ldflags -Wl,--no-as-needed
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO INSTALL
}
