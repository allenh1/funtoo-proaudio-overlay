# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils
RESTRICT="mirror"

DESCRIPTION="Open Movie Editor is designed to be a simple tool, that provides basic movie making capabilites."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://openmovieeditor.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=">=media-libs/libquicktime-1.0.0[lame,x264]
		>=x11-libs/fltk-1.1.7
		<x11-libs/fltk-2
		>=dev-libs/glib-2.10.3
		>=media-libs/portaudio-19_pre
		virtual/opengl
		>=media-libs/gavl-1.0.0
		>=media-libs/gmerlin-0.3.7
		>=media-libs/gmerlin-avdecoder-0.1.7
		media-sound/jack-audio-connection-kit
		>=media-libs/libsamplerate-0.1.1
		>=media-libs/libsndfile-1.0.0"
RDEPEND="${DEPEND}
		media-plugins/frei0r-plugins" # no real run-dep, but otherwise no plugins

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Fix linkage problem
	# http://www.openmovieeditor.org/board/viewtopic.php?id=873
	epatch ${FILESDIR}/openmovieeditor-fix-linkage.patch
	# Fix lame/x264 detection in libquicktime when as-needed used
	epatch "${FILESDIR}/openmovieeditor-fix-as-needed.patch"

	eautoreconf
}

src_compile(){
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO INSTALL
}
