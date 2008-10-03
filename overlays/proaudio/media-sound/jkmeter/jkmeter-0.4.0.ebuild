# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

RESTRICT="nomirror"
DESCRIPTION="Jkmeter is a combined RMS/digital peak meter based on the ideas of mastering guru Bob Katz"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
        >=media-libs/libclthreads-2.2.1
        >=media-libs/libclxclient-3.3.2
        >=media-libs/libclalsadrv-1.2.2"

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
	#dobin source/jkmeter
	cd "${S}"/source
	emake DESTDIR="${D}" install || die "install failed"
	cd .. ; dodoc README
}
