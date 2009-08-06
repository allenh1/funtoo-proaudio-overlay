# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="mirror"
IUSE=""
DESCRIPTION="preamp LADSPA plugins"
HOMEPAGE="http://quitte.de/dsp/preamp.html"
SRC_URI="http://quitte.de/dsp/${PN}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"
SLOT="0"

DEPEND="media-libs/ladspa-sdk"
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-Makefile.patch" || die "Patching failed!"
}

src_install() {
	dodir /usr/lib/ladspa
	make DESTDIR="${D}" install || die
	dodoc README
}
