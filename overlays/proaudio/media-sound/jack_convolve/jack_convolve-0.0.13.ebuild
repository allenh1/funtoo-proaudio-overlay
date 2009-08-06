# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="mirror"
IUSE="lash"
DESCRIPTION="jack_convolve - a simple commandline convolution engine for jackd"
HOMEPAGE="http://tapas.affenbande.org/?page_id=5"
SRC_URI="http://tapas.affenbande.org/jack_convolve/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"
RDEPEND=">=media-libs/libdsp-5.0.1
	>=media-sound/jack-audio-connection-kit-0.99
	>=media-libs/libconvolve-0.0.8
	media-libs/libsndfile
	media-libs/libsamplerate
	=sci-libs/fftw-3*
	lash? ( >=media-sound/lash-0.5.0 )"

src_unpack(){
	unpack "${A}"
	cd ${S}
	epatch "${FILESDIR}/Makefile-destdir.patch"
	sed -e "s:^PREFIX.*:PREFIX = /usr:" -i Makefile || die "changing prefix failed"
	 use lash || sed -i  '/pkg-config lash-1.0/d' Makefile || die "delete lash failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
}
