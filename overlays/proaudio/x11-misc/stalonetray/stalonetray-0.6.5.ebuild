# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="System tray utility including support for KDE system tray icons."
HOMEPAGE="http://stalonetray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="kde debug"

DEPEND=">=x11-base/xorg-x11-7.0-r1"
RDEPEND="${DEPEND}"

src_compile() {
	econf `use_with kde` `use_with debug` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README stalonetrayrc.sample TODO
	dohtml stalonetray.html
}
