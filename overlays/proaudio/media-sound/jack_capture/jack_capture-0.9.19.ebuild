# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

DESCRIPTION="Recording tool which default operation is to capture what goes out to the soundcard from JACK"
HOMEPAGE="http://www.notam02.no/arkiv/src"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="gui"

DEPEND=">=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.100"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	esed_check -i 's@gcc.*\(jack_capture.c\)@$(CC) $(CFLAGS) \1@g' Makefile 
}
src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin jack_capture
	use gui && dobin jack_capture_gui
	dodoc README
}
