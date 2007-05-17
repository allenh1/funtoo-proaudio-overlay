# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Gavl is short for Gmerlin Audio Video Library"
SRC_URI="http://prdownloads.sourceforge.net/gmerlin/${P}.tar.gz"
HOMEPAGE="http://gmerlin.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE=""
DEPEND="media-libs/libsamplerate"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

