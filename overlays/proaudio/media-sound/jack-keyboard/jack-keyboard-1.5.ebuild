# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils
RESTRICT="nomirror"
DESCRIPTION="virtual keyboard using JACK MIDI events"
HOMEPAGE="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/"
SRC_URI="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=">=x11-libs/gtk+-2.6
	>=media-sound/jack-audio-connection-kit-0.102.20"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/jack-keyboard-1.5-channel.patch"
	esed_check -i -e 's@\($(bindir)/jack\)@$(DESTDIR)\1@g' \
		-e 's@\($(man1dir)/jack\)@$(DESTDIR)\1@g' Makefile
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	make prefix="/usr" DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README TODO
	make_desktop_entry "${PN}" "JACK keyboard" \
	        "" "AudioVideo;Audio"

}
