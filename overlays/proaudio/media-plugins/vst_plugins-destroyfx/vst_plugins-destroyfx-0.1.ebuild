# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit vstplugin

MY_P="${PN/vst_plugins-/}"

DESCRIPTION="Collection of various DestroyFX plugins - native linux VST port"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=7"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/skidder.tar.bz2
		http://www.anticore.org/jucetice/wp-content/uploads/Scrubby.tar.bz2
		http://www.anticore.org/jucetice/wp-content/uploads/BufferOverride.tar.bz2
		http://www.anticore.org/jucetice/wp-content/uploads/Transverb.tar.bz2
		http://www.anticore.org/jucetice/wp-content/uploads/MonoMaker.tar.bz2"
RESTRICT="nomirror"

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
}

