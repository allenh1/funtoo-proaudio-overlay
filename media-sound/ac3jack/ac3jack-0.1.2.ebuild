# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Tool for creating an AC-3 (Dolby Digital) multichannel stream from its JACK input ports"
HOMEPAGE="http://essej.net/ac3jack/"
SRC_URI="http://essej.net/ac3jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=media-video/ffmpeg-0.4.6
	>=media-sound/jack-audio-connection-kit-0.80.0"
RDEPEND=""

src_install(){
	dodoc README NEWS
	make DESTDIR="${D}" install || die "make install failed"
}
