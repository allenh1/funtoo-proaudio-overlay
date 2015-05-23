# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Simple Tuner Interface for jack"
SRC_URI="mirror://sourceforge/guitarix/gxtuner/${P}.tar.bz2"
HOMEPAGE="http://sourceforge.net/projects/guitarix/files/gxtuner/"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=media-sound/jack-audio-connection-kit-0.116
	media-libs/zita-resampler
	sci-libs/fftw:3.0"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/include.patch"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README
}
