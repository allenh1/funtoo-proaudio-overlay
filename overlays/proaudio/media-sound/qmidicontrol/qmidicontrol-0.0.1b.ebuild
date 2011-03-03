# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils #qt3

# TODO: this ebuild needs some kde/qt3 eclass work -- will not function

DESCRIPTION="Virtual Midi Fader Box QMidiControl"
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=">=x11-libs/qt-3.2:3
	>=media-libs/alsa-lib-0.9.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
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
