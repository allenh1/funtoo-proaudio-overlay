# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git-r3

DESCRIPTION="synth engines from ZynAddSubFX and pack them in LV2 plugin format"
HOMEPAGE="http://home.gna.org/zyn"

EGIT_REPO_URI="http://repo.or.cz/r/zyn.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam1-9999
	=media-sound/zynjacku-9999"
DEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam1-9999
	|| ( media-libs/lv2 media-libs/lv2core )"

src_compile() {
	./waf configure --lv2-dir=/usr/$(get_libdir)/lv2 || die
	./waf || die
}

src_install() {
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README
}
