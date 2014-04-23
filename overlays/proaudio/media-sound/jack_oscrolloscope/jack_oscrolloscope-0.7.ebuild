# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base eutils toolchain-funcs

DESCRIPTION="Simple waveform viewer for JACK"
HOMEPAGE="http://das.nasophon.de/jack_oscrolloscope/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit
	media-libs/libsdl[audio,video]
	x11-libs/libX11
	virtual/opengl"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

DOCS=(README NEWS)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-linking.patch)

src_compile() {
	base_src_make CC="$(tc-getCC)"
}

src_install() {
	base_src_install PREFIX="${EPREFIX}"/usr
	make_desktop_entry "${PN}" "Jack_Oscrolloscope" "${PN}" "AudioVideo;Audio;Engineering;"
}
