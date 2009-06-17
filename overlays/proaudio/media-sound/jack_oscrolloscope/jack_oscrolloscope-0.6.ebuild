# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Simple waveform viewer for JACK"
HOMEPAGE="http://das.nasophon.de/jack_oscrolloscope/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0
	>=media-libs/mesa-7.3
	>=media-libs/libsdl-1.2.13"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	emake || die "Make failed"
}

src_install() {
#	emake PREFIX="${D}/usr" install || die "Install failed"
	mkdir -p "${D}/usr/bin"
	cp "${PN}" "${D}/usr/bin/" || die "Install failed"
	dodoc README NEWS
}
