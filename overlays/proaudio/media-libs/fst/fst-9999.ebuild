# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
DEPEND="lash? ( media-sound/lash )
	>=x11-libs/gtk+-2.0
	>=app-emulation/wine-0.9.5
	>=media-sound/jack-audio-connection-kit-0.98.1
	app-emulation/emul-linux-x86-gtklibs"

src_compile() {
	emake LASH_EXISTS="$(use lash && echo yes || echo no)" || die
}

src_install() {
	exeinto /usr/bin
	doexe fst.exe.so
	newexe fst.exe fst
}
