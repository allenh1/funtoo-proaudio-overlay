# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


MY_P="${PN/vst_plugins-/}"

DESCRIPTION="ZynAddSubFX native linux VST version"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=8"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""
S="${WORKDIR}/${MY_P}"

src_install() {
	dodir /usr/lib/vst
	exeinto /usr/lib/vst
	doexe *.so
	dodoc README.txt HISTORY.txt
}

