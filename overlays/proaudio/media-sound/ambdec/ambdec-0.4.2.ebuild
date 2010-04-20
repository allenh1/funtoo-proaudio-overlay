# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs multilib

RESTRICT="mirror"
DESCRIPTION="An Ambisonic decoder for first and second order"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2
	http://www.kokkinizita.net/linuxaudio/downloads/ambdec-manual.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1"

src_compile() {
	tc-export CC CXX
	cd "${S}/source"
	epatch "${FILESDIR}/${P}-Makefile.patch"
	esed_check -i -e "/^CPPFLAGS/ s/-O2//" "${S}/source/Makefile"
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die "make failed"
}

src_install() {
	cd "${S}/source"
	emake PREFIX="/usr" DESTDIR="${D}" install || die "install failed"
	cd ..
	dodoc AUTHORS README
	use doc && dodoc "$DISTDIR"/ambdec-manual.pdf
}
