# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/jackminimix/jackminimix-0.1.ebuild,v 1.1 2006/04/11 21:01:12 gimpel Exp $

DESCRIPTION="a simple mixer for the Jack Audio Connection Kit with an OSC based
control interface"
HOMEPAGE="http://www.ecs.soton.ac.uk/~njh/jackminimix"
SRC_URI="http://www.ecs.soton.ac.uk/~njh/jackminimix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
		>=media-libs/liblo-0.23"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS TODO ChangeLog
}
