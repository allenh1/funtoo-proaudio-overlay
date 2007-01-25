# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""

inherit eutils 
MY_P="${PN}-${PV/.1/-1}.src.041906"
DESCRIPTION="synthesiser emulation package for Moog, Sequential Circuits, Hammond and several other keyboards."
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="jack"

DEPEND="media-libs/alsa-lib
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )"
		
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
}

S="${WORKDIR}/bristol"

src_compile() {
	# hack in jack
	if use jack; then
		cp "${FILESDIR}"/build "${S}"/src || die
		cp "${FILESDIR}"/Makefile "${S}"/src/bristol/bristol || die
	fi
	# end
	cd ${S}/src
	./build clean || die "build failed"
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
