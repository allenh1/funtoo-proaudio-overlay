# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base toolchain-funcs

DESCRIPTION="A small utility that generates MIDI CC and OSC messages from the mouse position"
HOMEPAGE="http://github.com/fps/kontroll"
# snapshot straight from github, renamed and uploaded to proaudio distfiles
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="gnome-base/libglade:2.0
	media-libs/alsa-lib
	media-libs/liblo
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-master
RESTRICT="mirror"

DOCS=(README)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch)

src_compile() {
	CXX="$(tc-getCXX)" base_src_make PREFIX="${EPREFIX}/usr"
}

src_install() {
	base_src_install PREFIX="${EPREFIX}/usr"
}
