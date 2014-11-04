# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/gnuitar/gnuitar-0.3.2.ebuild,v 1.2 2006/04/10 16:35:53 gimpel Exp $

RESTRICT="mirror"
DESCRIPTION="a program for real-time guitar sound effect processing"
HOMEPAGE="http//www.gnuitar.com"
SRC_URI="mirror://sourceforge/gnuitar/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0
		virtual/pkgconfig"

src_compile() {
	econf --with-gtk2 || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README
}
