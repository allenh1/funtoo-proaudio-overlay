# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GPL'ed GTK oscilloscope-style musical instrument tuning program. It can also be used to find the frequency of sounds"
HOMEPAGE="http://pitchtune.sourceforge.net"
SRC_URI="mirror://sourceforge/pitchtune/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=x11-libs/gtk+-2*
		>=media-libs/alsa-lib-0.9"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog TODO
}


