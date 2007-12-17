# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="open source vinyl emulation"
HOMEPAGE="http://www.pogo.org.uk/xwax/"

SRC_URI="http://www.pogo.org.uk/xwax/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"


IUSE="aac cdparanoia ffmpeg mp3 vorbis"
DEPEND="media-libs/libsdl
	 media-libs/sdl-ttf"

RDEPEND="${DEPEND}
	aac? ( media-libs/faad2 )
	cdparanoia? ( media-sound/cdparanoia )
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac )
	mp3? ( media-sound/mpg123 )
	vorbis? ( media-sound/vorbis-tools )"

src_compile() {
	emake || die "Make failed"
}

src_install() {
	dobin xwax xwax_import || die "dobin failed"
	dodoc README
}
