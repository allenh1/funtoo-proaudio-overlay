# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/zynaddsubfx/zynaddsubfx-2.2.1-r2.ebuild,v 1.2 2005/06/30 13:25:03 josejx Exp $

inherit eutils zyn2

KEYWORDS="amd64 ~ppc x86"

MY_P=ZynAddSubFX-${PV}
DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${MY_P}.tar.bz2"
	
	#jackmidi? ( lash? (	http://www.student.nada.kth.se/~d00-llu/code_patches/zyn-lash-and-jackmidi-051205.diff ))
	#lash? ( !jackmidi? ( http://www.student.nada.kth.se/~d00-llu/code_patches/zyn_lash-0.5.0pre0.diff ))
	#jackmidi? (!lash? (	http://www.student.nada.kth.se/~d00-llu/code_patches/zyn-jackmidi-051205.diff ))"

RDEPEND="${DEPEND} !media-sound/zynaddsubfx-cvs"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.bz2 || die
	zyn_patches
	#exa_presets_instr_install
	unpack_examples_presets
}
