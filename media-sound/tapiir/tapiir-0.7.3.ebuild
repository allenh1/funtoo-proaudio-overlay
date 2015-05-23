# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils flag-o-matic multilib

DESCRIPTION="A flexible audio effects processor, inspired on the classical magnetic tape delay systems"
HOMEPAGE="http://www.resorama.com/maarten/tapiir/"
SRC_URI="http://www.resorama.com/maarten/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="examples"

DEPEND=">=media-libs/alsa-lib-0.9
	media-sound/jack-audio-connection-kit
	x11-libs/fltk:1"

RESTRICT="mirror"

DOCS=(AUTHORS doc/tapiir.txt)
HTML_DOCS=(doc/)

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch

	autotools-utils_src_prepare

	AT_NOELIBTOOLIZE=yes AT_M4DIR="m4" eautoreconf
}

src_configure() {
	append-cppflags -I/usr/include/fltk-1
	append-ldflags -L/usr/$(get_libdir)/fltk-1

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	doman doc/${PN}.1

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins doc/examples/*.mtd
	fi
}
