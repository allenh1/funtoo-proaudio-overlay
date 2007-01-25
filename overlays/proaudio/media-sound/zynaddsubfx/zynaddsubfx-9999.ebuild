# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils zyn2 cvs patcher

KEYWORDS="-*"
RESTRICT="nomirror"
MY_P=ZynAddSubFX-${PV}
# call function from zyn.eclass to get SRC_URI completed
DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/ZynAddSubFX-2.2.1.tar.bz2"

ECVS_SERVER="zynaddsubfx.cvs.sourceforge.net:/cvsroot/zynaddsubfx"
ECVS_MODULE="zynaddsubfx"
#ECVS_AUTH="pserver"
#ECVS_USER="anonymous"
#ECVS_PASS=""

RDEPEND="${DEPEND} !media-sound/zynaddsubfx-cvs"

S=${WORKDIR}/${ECVS_MODULE}
MY_PN="${PN/-cvs/}"
src_unpack() {
	cvs_src_unpack
	cd "${S}"
	patcher ""${FILESDIR}/jackmidi_ifdef.patch" apply"
	patcher ""${FILESDIR}/fix_jackmidi.patch" apply"
	unpack_examples_presets
}
