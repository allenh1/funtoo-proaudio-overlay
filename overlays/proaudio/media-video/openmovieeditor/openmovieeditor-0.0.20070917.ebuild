# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"

DESCRIPTION="Open Movie Editor is designed to be a simple tool, that provides basic movie making capabilites."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://openmovieeditor.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE=""
DEPEND=">=media-libs/libquicktime-0.9.7
		x11-libs/fltk
		media-libs/gavl
		media-sound/jack-audio-connection-kit
		media-libs/libsndfile"
RDEPEND="${DEPEND}
	media-plugins/frei0r-plugins" # no real run-dep, but otherwise no plugins

src_compile(){
	# workaround for newer ffmpeg
	CPPFLAGS="${CPPFLAGS} -D__STDC_CONSTANT_MACROS" econf || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
