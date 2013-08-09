# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Simple Tuner Interface for jack"
SRC_URI="mirror://sourceforge/guitarix/${PN}/${P}.tar.bz2"
HOMEPAGE="http://sourceforge.net/projects/guitarix/files/gxtuner/"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	dev-libs/glib:2
	media-libs/zita-resampler
	>=media-sound/jack-audio-connection-kit-0.116
	sci-libs/fftw:3.0
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_configure() {
	tc-export CXX
	default
}
