# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs

DESCRIPTION="Jkmeter is a combined RMS/digital peak meter based on the ideas of mastering guru Bob Katz"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/source

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix Makefile
	esed_check -i -e "s@\(^PREFIX.*\)@\PREFIX = /usr@g" \
		-e "s@\(/usr/bin/install[^\$]*\)@\1\$(DESTDIR)@g" Makefile
}

src_compile() {
	CXX="$(tc-getCXX)" emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ../AUTHORS ../README
}
