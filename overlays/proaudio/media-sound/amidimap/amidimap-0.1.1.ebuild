# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="nomirror"

DESCRIPTION="Read in, process and output MIDI events."
HOMEPAGE="http://www.cowlark.com/amidimap.html"
SRC_URI="http://www.cowlark.com/amidimap.dat/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=media-libs/alsa-lib-0.9"

src_compile() {
	emake || die
}

src_install() {
	dobin amidimap
	insinto /usr/share/${PN}
	doins psr300.map
	dodoc README
}
