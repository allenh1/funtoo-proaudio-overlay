# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/gneutronica/gneutronica-0.28.ebuild,v 1.2 2006/04/11 13:47:15 gimpel Exp $

EAPI=5
inherit base eutils toolchain-funcs

DESCRIPTION="A simple MIDI drum machine program modeled to a large extent on the Hydrogen drum machine software"
HOMEPAGE="http://gneutronica.sourceforge.net/"
SRC_URI="mirror://sourceforge/gneutronica/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="gnome-base/libgnomecanvas
	media-libs/alsa-lib
	x11-libs/gtk+:2"

RESTRICT="mirror"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-linking.patch )

src_compile() {
	base_src_make CC="$(tc-getCC)"
}

src_install() {
	base_src_install PREFIX="/usr"
	make_desktop_entry "${PN}" "gNeutronica" "${PN}_icon" "AudioVideo;Audio;Midi;"
}
