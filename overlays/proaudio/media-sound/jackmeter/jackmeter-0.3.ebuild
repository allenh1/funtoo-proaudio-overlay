# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Jack Meter is a basic console based DPM (Digital Peak Meter) for
JACK"
HOMEPAGE="http://www.ecs.soton.ac.uk/~njh/jackmeter"
SRC_URI="http://www.ecs.soton.ac.uk/~njh/jackmeter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS TODO
}

