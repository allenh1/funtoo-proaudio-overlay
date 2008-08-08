# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="PHASEX is an experimental software synthesizer for use with
Linux/ALSA/JACK"
HOMEPAGE="http://www.sysex.net/phasex"
SRC_URI="http://www.sysex.net/phasex/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8
		>=media-sound/jack-audio-connection-kit-0.100.0
		media-libs/alsa-lib"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9"

src_compile() {
	econf --enable-arch=`get-flag march` || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS TODO AUTHORS
	newicon "${S}/pixmaps/${PN}-icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "PHASEX" "${PN}" "AudioVideo;Audio;Synthesizer"
}

