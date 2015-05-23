# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="live looping sequencer"
HOMEPAGE="http://kluppe.klingt.org"
SRC_URI="http://kluppe.klingt.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	>=media-libs/liblo-0.23
	>=media-libs/libsndfile-1.0.11
	>=media-sound/jack-audio-connection-kit-0.90
	>=x11-libs/gtk+-2.6:2
	virtual/libusb"
RDEPEND="${DEPEND}"

my_make() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		INSTALL_PREFIX="${EPREFIX}/usr" \
		MAN_DIR="${EPREFIX}/usr/share/man/man1" $@
}

src_compile() {
	my_make
}

src_install() {
	my_make DESTDIR="${ED}" install
	make_desktop_entry ${PN} "Live Looping Sequencer" ${PN} "AudioVideo;Audio;Sequencer"
	newdoc CHANGES.log ChangeLog
	newdoc README.txt README
	dodoc TODO
}
