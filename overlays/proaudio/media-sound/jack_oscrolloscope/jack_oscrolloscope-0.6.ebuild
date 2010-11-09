# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Simple waveform viewer for JACK"
HOMEPAGE="http://das.nasophon.de/jack_oscrolloscope/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0
	>=media-libs/mesa-7.3
	>=media-libs/libsdl-1.2.13"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	epatch "${FILESDIR}/${P}-Makefile.patch"
	emake || die "emake failed"
}
src_install() {
	einstall DESTDIR="${D}" PREFIX=/usr || die "einstall failed"
	dodoc README NEWS
}
