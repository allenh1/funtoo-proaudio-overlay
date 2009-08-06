# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic
DESCRIPTION="Tapiir is a simple and flexible audio effects processor"
HOMEPAGE="http://www.iua.upf.es/~mdeboer/projects/tapiir/"
SRC_URI="http://www.iua.upf.es/~mdeboer/projects/tapiir/download/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="X"

DEPEND="media-sound/jack-audio-connection-kit
		>=x11-libs/gtk+-2.0.0
		media-libs/libsndfile
		dev-libs/libxml2
		media-libs/libsamplerate
		media-libs/alsa-lib
		>=x11-libs/fltk-1.0.0"

src_unpack() {
	append-ldflags -Wl,-z,now
	unpack ${A}
	cd ${S}
	#planetcrrma fixes
	epatch "${FILESDIR}/tapiir-0.7.1-alsa.patch"
	epatch "${FILESDIR}/tapiir-0.7.1-mtd.patch"
	epatch "${FILESDIR}/tapiir-0.7.1-multiline.patch"
	epatch "${FILESDIR}/tapiir-buffersizecallback.patch"
	epatch "${FILESDIR}/tapiir-gcc4.patch"

	# workaround for buggy Makefile
	sed -i 's/fltk_found=no/fltk_found=yes/g' configure
}

src_compile() {
	# check if fltk-1.* exists and set paths (ugly hack)
	[ -e /usr/lib/fltk-1.* ] && \
	local myconf="--with-fltk-inc-prefix=/usr/include/$(ls /usr/lib/|grep -m1 fltk-1)
	--with-fltk-prefix=/usr/lib/$(ls /usr/lib/|grep -m1 fltk-1)"

	econf $(use_with X x) ${myconf}|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS
}
