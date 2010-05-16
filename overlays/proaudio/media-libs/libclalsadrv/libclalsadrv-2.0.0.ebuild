# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils multilib toolchain-funcs

MY_P="${P/lib/}"

RESTRICT="mirror"
DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/alsa-lib"

S="${WORKDIR}/${MY_P}/libs"

src_unpack() {
	unpack ${A}
	cd "${S}"
	esed_check -i -e 's@g++@\$(CXX) \$(LDFLAGS)@g' -e '/^CPPFLAGS/ s/-O2//' \
		-e 's@\(\$(PREFIX)\)@\$(DESTDIR\)\1@g' \
		-e 's@\(/usr/bin/install -d\)@\1 $(DESTDIR)$(PREFIX)/include@g' \
		-e 's@.*ldconfig.*@@g' Makefile
}

src_compile() {
	tc-export CC CXX
	emake || die "emake failed"
}

src_install() {
	emake LIBDIR="$(get_libdir)" PREFIX="${D}/usr" install || die "make install failed"
	dodoc ../AUTHORS
}
