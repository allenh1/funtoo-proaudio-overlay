# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
RESTRICT="mirror"

DESCRIPTION="Open Movie Editor is designed to be a simple tool, that provides basic movie making capabilites."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://openmovieeditor.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="ffmpeg"
DEPEND=">=media-libs/libquicktime-1.0.2
		>=x11-libs/fltk-1.1.7
		<x11-libs/fltk-2
		>=dev-libs/glib-2.10.3
		>=media-libs/portaudio-19_pre
		media-libs/mesa
		ffmpeg? ( media-video/ffmpeg )
		>=media-libs/gavl-1.0.0
		media-sound/jack-audio-connection-kit
		>=media-libs/libsamplerate-0.1.1
		>=media-libs/libsndfile-1.0.0"
RDEPEND="${DEPEND}
		media-plugins/frei0r-plugins" # no real run-dep, but otherwise no plugins

src_unpack(){
	unpack ${A}
	cd ${S}

	# Fix linkage
	# http://www.openmovieeditor.org/board/viewtopic.php?pid=2027
	epatch ${FILESDIR}/openmovieeditor-fix-linkage.patch

	# ffmepg version api changes
	sed -i -e 's@\(avcodec_decode_audio\)(@\12(@g' \
		${S}/src/AudioFileFfmpeg.cxx

	# Get rid of annoying compilation warnings
	for icon in ${S}/icons/*.xpm ${S}/src/color_schemes.cxx; do
		sed -i -e 's@^\(static\)@\1 const@' $icon
	done
}

src_compile(){
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO INSTALL
}
