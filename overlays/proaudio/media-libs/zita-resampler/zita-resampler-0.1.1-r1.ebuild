# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs multilib

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	pushd libs
	CXX="$(tc-getCXX)" emake LIBDIR=$(get_libdir) || die
	# TODO: compile cli resampler app that's inside tarball
}

src_install() {
	pushd libs
	make DESTDIR="${D}" PREFIX=/usr LIBDIR=$(get_libdir) install || die
	popd

	dodoc AUTHORS

	if use doc ; then
		cd docs
		dohtml -r *
	fi
}
