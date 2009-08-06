# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils jackmidi
RESTRICT="mirror"
IUSE="debug"
DESCRIPTION="Dino is a pattern-based MIDI sequencer."
HOMEPAGE="http://dino.nongnu.org"

SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND=">=dev-cpp/libglademm-2.4.1
	>=dev-cpp/libxmlpp-2.6.1
	>=media-sound/jack-audio-connection-kit-0.102.6
	>=media-sound/lash-0.5.0"

src_unpack() {
	need_jackmidi
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/jack_midi_api_fix.diff"
}

src_compile() {
	econf $(use_enable debug) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
}
