# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="Wsynth-DSSI, a wavetable synthesizer plugin"
HOMEPAGE="http://www.gjcp.net/wsynth.html"
SRC_URI="http://www.gjcp.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="nomirror"

RDEPEND=">=media-libs/dssi-0.9
	>=x11-libs/gtk+-2.0"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog TODO README AUTHORS
	}
