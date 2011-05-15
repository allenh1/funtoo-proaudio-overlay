# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools

DESCRIPTION="din is a musical instrument and audio synthesizer"
HOMEPAGE="http://www.dinisnoise.org/"
SRC_URI="http://din.googlecode.com/files/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="virtual/opengl
		=dev-lang/tcl-8.5*
		media-sound/jack-audio-connection-kit
		media-libs/libsdl
		=sci-libs/fftw-3*
		media-libs/liblo
		net-libs/libircclient"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's:tcl8.5/::' -i configure.ac && \
		sed -e 's:vardir0=.*:vardir0=/var/lib/din/:' -i data/checkdotdin || \
		die "sed failed"
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install
}
