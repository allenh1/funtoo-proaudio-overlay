# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="nomirror"

DESCRIPTION="Configurable mixer for ALSA, with MIDI connectivity."
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND="media-libs/alsa-lib
	=x11-libs/qt-3*"

src_compile() {
	sed -ie "s:/usr/lib/qt3:/usr/qt/3:" make_qamix
	sed -ie "s:-O2 -g:\$(CFLAGS):" make_qamix
	make -f make_qamix || die
}

src_install() {
	dobin qamix
	dodoc README THANKS
	sed -ie "s:kamix:qamix:" qamix.desktop
	insinto /usr/share/applnk/Multimedia
	doins qamix.desktop
	insinto /usr/share/icons
	newins mini-kamix.png qamix.png
	insinto /usr/share/${PN}
	doins *.xml qamix_demo.ams
}
