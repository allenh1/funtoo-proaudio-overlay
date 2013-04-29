# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs multilib

DESCRIPTION="Successor of clalsadrv. API providing easy access to ALSA PCM devices"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib"

RESTRICT="mirror"

DOCS=(AUTHORS README)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch)

src_compile() {
	tc-export CXX
	cd libs
	emake
	cd ../apps
	emake
}

src_install() {
	cd libs
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="${EPREFIX}/usr" install
	cd ../apps
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	base_src_install_docs
}
