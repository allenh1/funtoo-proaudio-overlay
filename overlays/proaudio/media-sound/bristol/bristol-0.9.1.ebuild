# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""

inherit eutils

DESCRIPTION="synthesiser emulation package for Moog, Sequential Circuits, Hammond and several other keyboards."
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}-src.tgz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="media-libs/alsa-lib"

src_unpack() {
	unpack ${A}
}

S="${WORKDIR}/bristol"
src_compile() {
	cd ${S}/src
	./build || die "build failed"
}

src_install() {
	mkdir -p  "${D}/opt/bristol"
	cd ${S}
	mv bin  bitmaps  lib  memory "${D}/opt/bristol"
	dodoc readme.release
}

pkg_postinst(){
	einfo "$P is installed in /opt/bristol"
	einfo "start with  /opt/bristol/bin/startBristol"
	einfo "this ebuild is very experimental"
}
