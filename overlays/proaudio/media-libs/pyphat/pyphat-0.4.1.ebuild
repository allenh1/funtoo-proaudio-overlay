# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="python binding for phat"
HOMEPAGE="http://phat.berlios.de/"

SRC_URI="http://download.berlios.de/phat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE=""
DEPEND=">=media-libs/phat-0.4"

src_unpack() {
	unpack "${A}"
	cd "${S}"
}

src_compile() {
	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS || die "dodoc failed"
}
