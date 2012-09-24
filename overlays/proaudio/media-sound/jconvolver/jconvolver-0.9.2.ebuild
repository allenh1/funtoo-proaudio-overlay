# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs

DESCRIPTION="Command line convolution reverb by Fons Adriaensen"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2
	examples? ( http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${PN}-reverbs.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RESTRICT="mirror"

DEPEND=">=media-libs/libclthreads-2.4.0
	>=media-libs/libsndfile-1.0.17
	>=media-libs/zita-convolver-3.1.0
	>=media-sound/jack-audio-connection-kit-0.121.3
	>=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/source

DOCS=(../AUTHORS ../README ../README.CONFIG)

PATCHES=("${FILESDIR}/${P}-Makefile.patch")

src_compile() {
	CXX="$(tc-getCXX)" base_src_make
}

src_install() {
	base_src_install PREFIX="${EPREFIX}/usr"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/reverbs/*
	fi
}
