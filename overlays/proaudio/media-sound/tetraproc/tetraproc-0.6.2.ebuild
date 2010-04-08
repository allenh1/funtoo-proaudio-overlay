# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils multilib toolchain-funcs

RESTRICT="nomirror"
DESCRIPTION="TetraProc converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording."
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
        >=media-libs/libclthreads-2.4.0	
        >=media-libs/libclxclient-3.6.1"

S="${S}/source"
src_unpack() {
	unpack ${A}
	cd "${S}"
	esed_check -i -e 's@g++@\$(CXX) \$(LDFLAGS)@g' -e '/^CPPFLAGS/ s/-O2//' \
		-e "/^LIBDIR/ s/lib\$(SUFFIX)/$(get_libdir)/" \
		-e '/\/usr\/bin\/install/ s@\(\$(SHARED)\)@\$(DESTDIR)/\1@g' \
		-e '/\/usr\/bin\/install/ s@\(\$(PREFIX)\)@\$(DESTDIR)/\1@g' Makefile
}

src_compile() {
	tc-export CC CXX
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${D}/usr" install || die "make install failed"
	cd ..
	dodoc AUTHORS COPYING README
}
