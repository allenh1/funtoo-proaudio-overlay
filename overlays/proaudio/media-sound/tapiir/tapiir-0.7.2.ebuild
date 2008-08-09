# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic
DESCRIPTION="a flexible audio effects processor, inspired on the classical magnetic tape delay systems"
HOMEPAGE="http://www.iua.upf.es/~mdeboer/projects/tapiir/"
SRC_URI="http://www.iua.upf.es/~mdeboer/projects/tapiir/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="X"

DEPEND="media-sound/jack-audio-connection-kit
		>=x11-libs/gtk+-2.0.0
		media-libs/libsndfile
		dev-libs/libxml2
		media-libs/libsamplerate
		>=media-libs/alsa-lib-0.9
		>=x11-libs/fltk-1.0.0"

src_unpack() {
	append-ldflags -Wl,-z,now
	unpack ${A}
	cd ${S}
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
	emake DESTDIR="${D}" install || die "emake install failed."
	doman doc/${PN}.1
	dodoc AUTHORS doc/${PN}.txt
	dohtml doc/*.html doc/images/*.png
	insinto /usr/share/${PN}/examples
	doins doc/examples/*.mtd || die "doins failed."
}
