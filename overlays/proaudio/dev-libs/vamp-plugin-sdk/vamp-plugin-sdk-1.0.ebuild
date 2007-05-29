# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Vamp cross-platform SDK for Vamp plugins"
HOMEPAGE="http://www.vamp-plugins.org/develop.html"
SRC_URI="mirror://sourceforge/sv1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-util/pkgconfig-0.9"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
}

