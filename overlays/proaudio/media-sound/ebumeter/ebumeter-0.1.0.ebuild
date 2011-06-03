# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

RESTRICT="mirror"
DESCRIPTION="Loudness measurement according to EBU-R128"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.0
	media-libs/libsndfile
        media-libs/libpng"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix Makefile
	esed_check -i -e "s@\(^PREFIX.*\)@\PREFIX = /usr@g" \
		-e "s@\(/usr/bin/install[^\$]*\)@\1\$(DESTDIR)@g" "source/Makefile"
}

src_compile() {
	cd source;
	emake || die "make failed"
}

src_install() {
	cd "${S}"/source
	emake DESTDIR="${D}" install || die "install failed"
	cd .. ; dodoc AUTHORS README
	docinto pdf
	dodoc ${S}/doc/*
	make_desktop_entry ${PN} ebumeter ${PN} "AudioVideo;Audio;"
}
