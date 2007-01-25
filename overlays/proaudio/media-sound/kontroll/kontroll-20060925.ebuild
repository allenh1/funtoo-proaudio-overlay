# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="A small utility that generates midi cc messages from the mouse
position"
HOMEPAGE="http://tapas.affenbande.org/?page_id=42"
SRC_URI="http://affenbande.org/~tapas/${PN}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="
	media-libs/alsa-lib
	>=x11-libs/gtk+-2.0
	gnome-base/libglade
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}"
src_unpack(){
	unpack "${A}"
	cd ${S}
	epatch "${FILESDIR}/Makefile-destdir.patch"
	sed -e "s:^PREFIX.*:PREFIX = /usr:" -i Makefile || die "changing prefix failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
