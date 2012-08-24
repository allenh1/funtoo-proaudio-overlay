# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs multilib

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsndfile"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile-v2.patch"
	# link directly by path to work around failure with zresample application
	sed -i -e "s|-lzita-resampler|../libs/libzita-resampler.so.${PV}|" \
		apps/Makefile || die
}

src_compile() {
	cd libs
	CXX="$(tc-getCXX)" emake LIBDIR=$(get_libdir) || die "make libs failed"

	cd ../apps
	CXX="$(tc-getCXX)" emake LIBDIR=$(get_libdir) || die "make apps failed"
}

src_install() {
	cd libs
	emake DESTDIR="${D}" PREFIX=/usr \
		LIBDIR=$(get_libdir) install || die "install libs failed"

	cd ../apps
	emake DESTDIR="${D}" PREFIX=/usr \
		LIBDIR=$(get_libdir) install || die "install apps failed"
	cd ..

	dodoc AUTHORS README

	cd docs
	dohtml -r *
}
