# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils qt3

DESCRIPTION="Virtual Midi Fader Box QMidiControl"
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="$(qt_min_version 3.2)
	>=media-libs/alsa-lib-0.9.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-qtbasedir.patch
	sed -i -e "s:^\(CXXFLAGS\)\(.*\):\1+\2:"  -e 's:gcc:$(CXX):g' make_qmidicontrol
}

src_compile() {
	make -f make_qmidicontrol || die
}

src_install() {
	dobin qmidicontrol
	dodoc LICENSE README
}
