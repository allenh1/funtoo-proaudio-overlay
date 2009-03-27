# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

RESTRICT="nomirror"
DESCRIPTION="Gui for ld10k1 (EMU10K1 (EMU10K2) effect loader for ALSA)"
HOMEPAGE="http://ld10k1.sourceforge.net/"
SRC_URI="mirror://sourceforge/ld10k1/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE=""
DEPEND=">=media-libs/ld10k1-0.1.8
	>=x11-libs/qt-3.2:3"

src_install() {
	make DESTDIR="${D}" install || die "Installation failed."
	dodoc AUTHORS COPYING INSTALL NEWS README TODO || die "Doc installation failed."
}
