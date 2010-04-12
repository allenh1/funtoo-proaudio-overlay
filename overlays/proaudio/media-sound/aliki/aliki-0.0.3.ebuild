# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs multilib

RESTRICT="mirror"
DESCRIPTION="Aliki is an integrated system for Impulse Response measurements"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2
	http://www.kokkinizita.net/linuxaudio/downloads/aliki-manual.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	>=media-libs/libsndfile-1.0.18"

S="${WORKDIR}/${PN}"

src_compile() {
	tc-export CC CXX
	epatch "${FILESDIR}/${P}-makefile.patch"
	esed_check -i -e '/^CPPFLAGS/ s/-O3//' "${S}/Makefile"
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die "make failed"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "install failed"
	use doc && dodoc "${DISTDIR}/aliki-manual.pdf"
}
