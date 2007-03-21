# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://freebob.sf.net"
SRC_URI="mirror://sourceforge/freebob/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ~ppc ~ppc-macos ~mips"

IUSE=""

DEPEND=">=media-libs/alsa-lib-1.0.0
	>=dev-libs/libxml2-2.6.0
	>=sys-libs/libraw1394-1.2.1
	>=media-libs/libiec61883-1.1.0
	>=sys-libs/libavc1394-0.5.3
	>=media-sound/jack-audio-connection-kit-0.102.20"

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
