# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base toolchain-funcs

DESCRIPTION="An integrated system for Impulse Response measurements"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2
	doc? ( http://kokkinizita.linuxaudio.org/linuxaudio/downloads/aliki-manual.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	>=media-libs/libsndfile-1.0.18
	>=media-libs/zita-alsa-pcmi-0.2.0
	>=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}/source

RESTRICT="mirror"

DOCS=(../AUTHORS ../README)

PATCHES=("${FILESDIR}/${P}-Makefile.patch")

src_compile() {
	base_src_make CXX="$(tc-getCXX)" PREFIX="/usr"
}

src_install() {
	use doc && DOCS+=("${DISTDIR}/aliki-manual.pdf")

	base_src_install PREFIX="/usr"
}
