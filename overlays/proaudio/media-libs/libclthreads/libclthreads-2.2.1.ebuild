# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils multilib toolchain-funcs

MY_P="clthreads-${PV}"
MY_A="${MY_P}"

S="${WORKDIR}/${MY_P}"

RESTRICT="nomirror"
DESCRIPTION="An audio library by Fons Adriaensen <fons@kokkinizita.net>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_A}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
