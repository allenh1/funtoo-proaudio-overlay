# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

RESTRICT="nomirror"
DESCRIPTION="horgand is an opensource software organ."
HOMEPAGE="http://personal.telefonica.terra.es/web/soudfontcombi/"
SRC_URI="http://download.berlios.de/horgand/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND=">=x11-libs/fltk-1.1.2
	media-libs/libsndfile
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
