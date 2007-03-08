# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclalsadrv/libclalsadrv-1.0.1.ebuild,v 1.10 2006/03/06 14:46:58 flameeyes Exp $

IUSE=""

inherit eutils multilib toolchain-funcs exteutils

MY_P="clalsadrv-${PV}"
MY_A="${MY_P}"

RESTRICT="nomirror"
DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_A}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~ppc"

DEPEND=">=media-libs/libclthreads-2.0.1
	media-libs/alsa-lib"

#S="${WORKDIR}/clalsadrv"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	esed -i -e 's@\(\$(PREFIX)\)@\$(DESTDIR\)\1@g' Makefile
	esed -i -e 's@\(/usr/bin/install -d\)@\1 $(DESTDIR)$(PREFIX)/include@g' Makefile
}

src_compile() {
	tc-export CC CXX
	emake || die "emake failed"
}

src_install() {
	make CLALSADRV_LIBDIR="/usr/$(get_libdir)" DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS
}
