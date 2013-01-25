# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="5"

inherit eutils multilib toolchain-funcs

MY_P="${P/lib/}"

S="${WORKDIR}/${MY_P}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXft
	>=media-libs/freetype-2
	>=media-libs/libclthreads-2.4.0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}usr" LIBDIR="$(get_libdir)" || die "emake failed"
}

src_install() {
	emake PREFIX="${EPREFIX}usr" LIBDIR="$(get_libdir)" DESTDIR="${D}" install || die "make install failed"
	dosym "${PN}.so.${PV}" "${EPREFIX}usr/$(get_libdir)/${PN}.so.3"
	dodoc AUTHORS
}
