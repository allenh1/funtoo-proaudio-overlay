# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="nomirror"
IUSE="lash"
DESCRIPTION="A convolution plugin for linux/DSSI"
HOMEPAGE="http://tapas.affenbande.org/?page_id=36"
SRC_URI="http://tapas.affenbande.org/jack_convolve/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=media-libs/libdsp-5.0.1
	>=x11-libs/gtk+-2.0
	>=media-libs/dssi-0.9.1
	>=media-libs/libconvolve-0.0.8
	>=gnome-base/libglade-2.0
	media-libs/liblo
	dev-util/pkgconfig
	media-libs/libsamplerate
	media-libs/libsndfile"

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
	dodoc AUTHORS README
}
