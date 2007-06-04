# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit vstplugin

MY_P="${PN/vst_plugins-/}-v${PV}"

DESCRIPTION="Lightweight soundfont player - VST plugin"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=29"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
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

