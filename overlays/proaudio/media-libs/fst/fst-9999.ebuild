# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

DESCRIPTION="FreeST audio plugin VST container library"
HOMEPAGE="http://joebutton.co.uk/fst/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"
EGIT_REPO_URI="git://repo.or.cz/fst.git"
IUSE="lash"

SRC_URI=""

KEYWORDS=""
RDEPEND="
	lash? ( media-sound/lash[abi_x86_32(-)] )
	x11-libs/gtk+:2[abi_x86_32(-)]
	app-emulation/wine[abi_x86_32(-)]
	media-sound/jack-audio-connection-kit[abi_x86_32(-)]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_compile() {
	emake LASH_EXISTS="$(use lash && echo yes || echo no)"
}

src_install() {
	exeinto /usr/bin
	doexe fst.exe.so
	newexe fst.exe fst
}
