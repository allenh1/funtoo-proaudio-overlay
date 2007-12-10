# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils jackmidi cvs
RESTRICT="nomirror"
IUSE="debug"
DESCRIPTION="Dino is a pattern-based MIDI sequencer."
HOMEPAGE="http://dino.nongnu.org"

#SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"
ECVS_SERVER="cvs.savannah.nongnu.org:/sources/dino"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-cpp/libglademm-2.4.1
	>=dev-cpp/libxmlpp-2.6.1
	>=media-sound/jack-audio-connection-kit-9999
	>=media-sound/lash-0.5.0"

src_unpack() {
	need_jackmidi
	cvs_src_unpack
	cd ${S}
	#epatch "${FILESDIR}/jack_midi_api_fix.diff"
}

src_compile() {
	econf $(use_enable debug) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
}
