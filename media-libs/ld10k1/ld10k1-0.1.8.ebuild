# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="EMU10K1 (EMU10K2) effect loader for ALSA"
HOMEPAGE="http://ld10k1.sourceforge.net/"
SRC_URI="mirror://sourceforge/ld10k1/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE=""
DEPEND=">=media-libs/alsa-lib-1.0.8"

src_install() {
	make DESTDIR="${D}" install || die "Installation failed."
	rm doc/Makefil*
	rm contrib/Makefil*
	rm dump/Makefil*
	dodoc AUTHORS COPYING COPYING.LIB INSTALL NEWS README TODO || die "Doc installation failed."
	docinto doc
	dodoc doc/* || die "Doc syntaxe installation failed."
	docinto contrib
	dodoc contrib/* || die "Contrib installation failed"
	docinto dump
	dodoc dump/* || die "Dump installation failed"
	docinto effects
	dodoc setup/effects/*.asm setup/effects/README || die "Effects asm examples installation failed"
}
