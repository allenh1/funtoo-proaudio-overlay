# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit autotools-utils

DESCRIPTION="din is a musical instrument and audio synthesizer"
HOMEPAGE="http://www.dinisnoise.org/"
SRC_URI="http://din.googlecode.com/files/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DOCS=( AUTHORS BUGS CHANGELOG README TODO )

DEPEND="virtual/opengl
		=dev-lang/tcl-8.5*
		media-sound/jack-audio-connection-kit
		media-libs/libsdl
		=sci-libs/fftw-3*
		media-libs/liblo
		net-libs/libircclient"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

src_prepare() {
	sed -e 's:tcl8.5/::' -i configure.ac && \
		sed -e 's:vardir0=.*:vardir0=/var/lib/din/:' -i data/checkdotdin || \
		die "sed failed"
	autotools-utils_src_prepare
}
