# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit kde

RESTRICT="mirror"
DESCRIPTION="Ecamegapedal is a real-time effect processor."
HOMEPAGE="http://www.wakkanet.fi/~kaiv/ecamegapedal/"
SRC_URI="http://ecasound.seul.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE="jack"
need-kde 3.5

DEPEND="jack? ( media-sound/jack-audio-connection-kit )
	>=media-sound/ecasound-2.2.0"

src_unpack() {
	unpack ${A}
}

src_configure() {
	econf `use_enable jack` || die
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS README TODO
}
