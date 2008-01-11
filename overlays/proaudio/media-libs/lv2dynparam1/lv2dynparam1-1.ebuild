# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="LV2 dynparam extension"
HOMEPAGE="http://home.gna.org/lv2dynparam/"
SRC_URI="http://download.gna.org/lv2dynparam/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/" || die "source for ${PN} not found"
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS
}
