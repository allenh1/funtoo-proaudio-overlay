# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-crystal/fvwm-crystal-3.0.4.ebuild,v 1.6 2007/02/04 19:20:09 beandog Exp $

DESCRIPTION="Crystal-Audio artwork compilation for FVWM-Crystal"
HOMEPAGE="http://fvwm-crystal.sourceforge.net/"
SRC_URI="mirror://sourceforge/crystal-audio/${P}.tar.bz2"
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">x11-themes/fvwm-crystal-3.0.4"

src_compile() {
	einfo "There is nothing to compile."
}

src_install() {
	rm icons/filelist wallpapers/filelist
	einstall || die "einstall failed"
	dodoc AUTHORS COPYING README INSTALL NEWS ChangeLog
}
