# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils multilib toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="A-format to B-format signal converter for tetrahedral Ambisonic
microphones"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1"

S="${S}/source"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
	esed_check -i -e '/^CPPFLAGS/ s/-O3//' Makefile
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "make install failed"
	cd ..
	dodoc AUTHORS README
}
