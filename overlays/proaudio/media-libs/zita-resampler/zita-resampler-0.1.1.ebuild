# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils toolchain-funcs multilib

MY_P=${P/lib/}

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}/libs"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	tc-export CXX
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" PREFIX=/usr \
		LIBDIR=$(get_libdir) install || die "make install failed"

	dodoc ../AUTHORS

	if use doc ; then
		cd ../docs || die "cd ../docs failed"
		dohtml -r *
	fi
}
