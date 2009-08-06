# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="simple tool to capture what goes out to soundcard from JACK"
HOMEPAGE="http://ccrma.stanford.edu/~kjetil/src"
SRC_URI="http://ccrma.stanford.edu/~kjetil/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin jack_capture
	dodoc README
}
