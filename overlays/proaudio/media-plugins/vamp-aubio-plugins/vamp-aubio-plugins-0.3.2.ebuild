# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Onset detection, pitch tracking, note tracking and tempo tracking
plugins for Vamp"
HOMEPAGE="http://www.vamp-plugins.org"
SRC_URI="mirror://sourceforge/vamp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/aubio-0.3.0"
DEPEND="${REDEPEND}
		>=dev-libs/vamp-plugin-sdk-1.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-makefile.patch"
	sed -i -e 's|FLOOR|floor|g' plugins/Notes.cpp || die "sed failed"
}

src_compile() {
	emake || die "make filed"
}

src_install() {
	exeinto /usr/lib/vamp
	doexe vamp-aubio.so
	insinto /usr/lib/vamp
	doinst *.cat
	dodoc README
}



