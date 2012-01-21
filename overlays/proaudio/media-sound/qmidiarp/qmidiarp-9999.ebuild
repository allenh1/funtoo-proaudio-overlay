# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git-2 autotools

DESCRIPTION="MIDI Arpeggiator QMidiArp"
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

EGIT_REPO_URI="git://qmidiarp.git.sourceforge.net/gitroot/qmidiarp/qmidiarp"

DEPEND=">=x11-libs/qt-core-4.2:4[qt3support]
	>=x11-libs/qt-gui-4.2:4[qt3support]
	>=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/alsa-lib-0.9.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	git-2_src_unpack
	cd "$S"
	eautoreconf
}

src_install() {
	make DESTDIR="$D" install || die "install failed"
	dodoc README
}
