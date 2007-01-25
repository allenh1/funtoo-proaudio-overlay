# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="preamp LADSPA plugins"
HOMEPAGE="http://quitte.de/dsp/preamp.html"
SRC_URI="http://quitte.de/dsp/${PN}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="media-libs/ladspa-sdk"
S="${WORKDIR}/${PN}"
src_compile() {
#	econf || die
	emake || die
}

src_install() {
	dodir /usr/lib/ladspa
	make DEST=${D}/usr/lib/ladspa install || die
	dodoc README
}
