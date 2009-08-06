# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="Ecamegapedal is a real-time effect processor."
HOMEPAGE="http://www.wakkanet.fi/~kaiv/ecamegapedal/"
SRC_URI="http://ecasound.seul.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE="jack"

DEPEND="=x11-libs/qt-3*
	jack? ( media-sound/jack-audio-connection-kit )
	>=media-sound/ecasound-2.2.0"

src_compile() {
	econf `use_enable jack` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS README TODO
}
