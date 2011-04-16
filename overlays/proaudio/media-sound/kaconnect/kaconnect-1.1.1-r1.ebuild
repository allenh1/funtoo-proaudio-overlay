# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit kde toolchain-funcs

IUSE=""

DESCRIPTION="Part of Kalsatools - QT based frontend to aconnect"
HOMEPAGE="http://www.suse.de/~mana/kalsatools.html"
SRC_URI="ftp://ftp.suse.com/pub/people/mana/kalsatools-current/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="media-sound/alsa-utils"

DEPEND="${RDEPEND}
	sys-apps/sed"

need-kde 3.5

src_unpack() {
	unpack ${A} || die
	cd ${S}
	sed -i -e "s:gcc:$(tc-getCC) ${CFLAGS}:g" \
		-e 's:/usr/lib/qt3:/usr/qt/3:g' make_kaconnect
	sed -i -e 's@ConnectorWidget::@@g' connector.h
}

src_configure() {
	einfo "No configure script"
}

src_compile() {
	make -f make_kaconnect || die "Make failed."
}

src_install () {
	dobin kaconnect
	dodoc README THANKS LICENSE kalsatools.changes
}
