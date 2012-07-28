# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

RESTRICT="mirror"
DESCRIPTION="live looping sequencer"
HOMEPAGE="http://kluppe.klingt.org"
SRC_URI="http://kluppe.klingt.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.90
		>=x11-libs/gtk+-2.6
		dev-libs/libxml2
		>=media-libs/liblo-0.23
		>=dev-libs/libusb-0.1.11
		>=media-libs/libsndfile-1.0.11"

src_unpack() {
	unpack ${A}
	cd "${S}"
	esed_check -i -e "s@\(^CFLAGS\ *\=\ *-pthread\)\ *-O3@\1 ${CFLAGS}@g" \
		Makefile
}

src_compile() {
		sed -i -s 's:/local::g' "Makefile"
		emake || die "make failed"
}

src_install() {
		dobin src/frontend/kluppe/kluppe
		insinto /usr/share/pixmaps
		doins src/frontend/kluppe/kluppe.png
		newdoc CHANGES.log ChangeLog
		newdoc README.txt README
		dodoc TODO
		make_desktop_entry "${PN}" "Live Looping Sequencer" "${PN}" "AudioBideo;Audio;Sequencer"
}

