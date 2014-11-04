# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/madjack/madjack-0.4.ebuild,v 1.2 2006/04/11 20:53:30 gimpel Exp $

DESCRIPTION="MadJACK is a MPEG Audio Deck for the Jack Audio Connection Kit with
an OSC based control interface"
HOMEPAGE="http://www.ecs.soton.ac.uk/~njh/madjack/"
SRC_URI="http://www.ecs.soton.ac.uk/~njh/madjack/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-libs/liblo-0.23
		>=media-libs/libmad-0.15
		>=media-sound/jack-audio-connection-kit-0.100
		virtual/pkgconfig"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS TODO ChangeLog
}

