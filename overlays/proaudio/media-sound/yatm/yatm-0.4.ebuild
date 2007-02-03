# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#IUSE="speex ogg sndfile"
IUSE=""

RESTRICT="nomirror"
DESCRIPTION="adjust the playback speed without changing the pitch of the
recording"
HOMEPAGE="http://delysid.org/yatm.html"
SRC_URI="http://delysid.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND="media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/alsa-lib
	media-libs/speex"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
