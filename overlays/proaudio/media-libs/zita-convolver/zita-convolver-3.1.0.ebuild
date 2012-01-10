# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit base toolchain-funcs multilib

DESCRIPTION="A high performance audio signal convolver library"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/libs"

PATCHES=("${FILESDIR}/${P}-Makefile.patch")

src_compile() {
	CXX="$(tc-getCXX)" emake || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR="$(get_libdir)" install || die
	dodoc ../AUTHORS ../README
}
