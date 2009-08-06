# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="mirror"

DESCRIPTION="Joystick to ALSA MIDI sequencer converter."
HOMEPAGE="http://terminatorx.org/aseqjoy.html"
SRC_URI="http://terminatorx.org/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=media-libs/alsa-lib-0.9"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
}
