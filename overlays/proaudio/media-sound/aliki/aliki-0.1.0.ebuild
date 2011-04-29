# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils toolchain-funcs multilib

DESCRIPTION="Aliki is an integrated system for Impulse Response measurements"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2
	doc? ( http://kokkinizita.linuxaudio.org/linuxaudio/downloads/aliki-manual.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	>=media-libs/libsndfile-1.0.18
	>=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}/source

RESTRICT="mirror"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	CXX="$(tc-getCXX)" emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die
	dodoc ../AUTHORS ../README
	use doc && dodoc "${DISTDIR}/aliki-manual.pdf"
}
