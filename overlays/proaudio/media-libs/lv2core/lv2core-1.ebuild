# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils

DESCRIPTION="SLV2 is a library for LV2 hosts"
HOMEPAGE="http://lv2plug.in"
SRC_URI="http://lv2plug.in/spec/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=dev-util/pkgconfig-0.9.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/" || die "source for ${PN} not found"
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}
