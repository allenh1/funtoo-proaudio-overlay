# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="nomirror"
DESCRIPTION="A program for doing sound effects using one gigantic fft analysis (no windows)."
HOMEPAGE="http://www.notam02.no/arkiv/doc/mammut/"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100
	media-libs/libsndfile
	media-libs/juce
	>=media-libs/libsamplerate-0.1.1
	media-libs/libvorbis"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"/src
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	cd "${S}/src"
	emake || die "make failed"
}

src_install() {
	if use doc; then
		dodoc doc/mammuthelp.html
	fi
	newicon "icons/icon.png" "${PN}.png"
	cd src/
	make DESTDIR="${D}" install || die "install failed" 
	make_desktop_entry "${PN}" "Mammut" "${PN}" "AudioVideo;Audio;"
}
