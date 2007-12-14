# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Low-level feature extraction plugins for Vamp"
HOMEPAGE="http://www.vamp-plugins.org"
SRC_URI="mirror://sourceforge/vamp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libxtract"
DEPEND="${RDEPEND}
		>=media-libs/vamp-plugin-sdk-1.0"


src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	exeinto /usr/lib/vamp
	doexe *.so
	insinto /usr/lib/vamp
	doins *.cat
	dodoc README STATUS
}

