# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="nomirror"

DESCRIPTION="Multithreaded stereo recording tool."
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	=x11-libs/qt-3*"

src_compile() {
	sed -ie "s:/usr/lib/qt3:/usr/qt/3:" make_qarecord
	sed -ie "s:-O2 -g:\$(CFLAGS):" make_qarecord
	make -f make_qarecord || die
}

src_install() {
	dobin qarecord
}
