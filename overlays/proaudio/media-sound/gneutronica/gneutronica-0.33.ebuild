# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/gneutronica/gneutronica-0.28.ebuild,v 1.2 2006/04/11 13:47:15 gimpel Exp $

inherit eutils

DESCRIPTION="a simple MIDI drum machine program modeled to a large extent on the
Hydrogen sample-based drum machine software"
HOMEPAGE="http://gneutronica.sourceforge.net/"
SRC_URI="mirror://sourceforge/gneutronica/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=gnome-base/libgnomecanvas-2*
		>=x11-libs/gtk+-2.0"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
