# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


MY_P="${PN/vst_plugins-/}-v${PV}"

DESCRIPTION="6-Band graphic VST Equalizer"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=7"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="mirror"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""
S="${WORKDIR}"

src_install() {
	dodir /usr/lib/vst
	exeinto /usr/lib/vst
	doexe *.so
	dodoc readme.txt
}

