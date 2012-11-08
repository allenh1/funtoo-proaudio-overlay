# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs

DESCRIPTION="A jack multichannel audio level meter app featuring correct ballistics for both the VU and the PPM"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.0
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	x11-libs/cairo"
RDEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/source
RESTRICT="mirror"

DOCS=(../AUTHORS ../README)

PATCHES=("${FILESDIR}"/${P}-Makefile.patch)

src_compile() {
	base_src_make CXX="$(tc-getCXX)" PREFIX="${EPREFIX}/usr"
}

src_install() {
	base_src_install PREFIX="${EPREFIX}/usr"
}
