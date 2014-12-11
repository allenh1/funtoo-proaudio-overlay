# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs multilib

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsndfile"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

DOCS=(AUTHORS README)
HTML_DOCS=(docs/)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch)

src_compile() {
	tc-export CXX
	cd libs
	base_src_make

	cd ../apps
	base_src_make
}

src_install() {
	cd libs
	base_src_make DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
		LIBDIR=$(get_libdir) install

	cd ../apps
	base_src_make DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	cd ..

	base_src_install_docs
}
