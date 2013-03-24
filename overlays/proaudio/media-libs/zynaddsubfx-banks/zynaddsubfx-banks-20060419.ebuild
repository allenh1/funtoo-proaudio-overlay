# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zyn3
RESTRICT="mirror"
MY_P="${P/zynaddsubfx-/}"
MY_P="${MY_P/-/}"
DESCRIPTION="ZynAddSubFX banks/instruments"
HOMEPAGE="http://zynaddsubfx.sourceforge.net/doc/instruments/"

SRC_URI="http://zynaddsubfx.sourceforge.net/doc/instruments/${MY_P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="|| ( !<media-sound/zynaddsubfx-2.2.1-r4 media-sound/yoshimi )"

S="${WORKDIR}/banks"
pkg_setup(){
	# tell the user to use the "smart" version of this ebuild
	# which tries to fetch the latest source
	use_smart
}

src_unpack(){
	unpack ${A}
	mv banks* banks
	cd "${S}"
	find -name 'CVS' -exec rm -rf {} \; &>/dev/null
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	target="/usr/share/zynaddsubfx"
	insinto  "${target}"
	doins -r "${S}"
}

pkg_postinst() {
	einfo "This packages provides banks/instruments for zynaddsubfx"
	einfo "They are located in ${target}"
	einfo "wich is the default location where zynaddsubfx is looking"
	einfo "for banks/instruments"
	einfo "If you think you've created a nice instrument and want to"
	einfo "share. Send it to zynaddsubfx-user@lists.sourceforge.net or"
	einfo "stamm@flashmail.com"
	einfo
	einfo "you can also emerge the ~${ARCH} version of this ebuild"
	einfo "which tries to fetch the latest tarball"
}
