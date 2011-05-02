# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit toolchain-funcs

DESCRIPTION="measures the latency between two jack ports with subsample accuracy"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

RESTRICT="mirror"

src_prepare() {
	sed -i -e "s/g++/\$(CXX)/" -e "s/-O2//" -e "s/-march=native//" \
		Makefile || die
}

src_compile() {
	CXX="$(tc-getCXX)" emake || die
}

src_install() {
	dobin jack_delay
	dodoc AUTHORS README
}
