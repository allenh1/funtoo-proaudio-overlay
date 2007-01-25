# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils qt3

DESCRIPTION="Midi router and filter utility QMidiRoute"
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
	epatch ${FILESDIR}/${P}-fixqtbasedir.patch
	sed -i -e "s:^\(CXXFLAGS\)\(.*\):\1+\2:"  -e 's:gcc:$(CXX):g' make_qmidiroute
}

src_compile() {
	make -f make_qmidiroute || die
}

src_install() {
	dobin qmidiroute
	dodoc LICENSE README
	insinto /usr/share/${PN}
	doins aeolus01.qmr
}
