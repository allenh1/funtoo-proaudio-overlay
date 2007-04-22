# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Collection of ported VST plugins from cern"
HOMEPAGE="http://cern.linux.vst.googlepages.com"
SRC_URI="http://cern.linux.vst.googlepages.com/abfpan.tar.bz2
		http://cern.linux.vst.googlepages.com/bfreflector.tar.bz2
		http://cern.linux.vst.googlepages.com/killerringer.tar.bz2
		http://cern.linux.vst.googlepages.com/loser-dev.tar.bz2
		http://cern.linux.vst.googlepages.com/waveplug.tar.bz2
		http://cern.linux.vst.googlepages.com/msmatrix.tar.bz2
		http://cern.linux.vst.googlepages.com/midigain.tar.bz2
		http://cern.linux.vst.googlepages.com/refuzznik.tar.bz2"
RESTRICT="nomirror"
S="${WORKDIR}"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	einfo "Installing binaries. Nothing to compile"
}

src_install() {
	dodir /usr/lib/vst
	insinto /usr/lib/vst
	doins *.so
}
