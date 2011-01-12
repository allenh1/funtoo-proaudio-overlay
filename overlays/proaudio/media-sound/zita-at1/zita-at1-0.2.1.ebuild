# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="An autotuner, normally used to correct the pitch of a voice singing (slightly) out of tune"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	>=media-libs/zita-resampler-0.1.1
	media-sound/jack-audio-connection-kit
	>=sci-libs/fftw-3.2.2:3.0"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/source"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	CXX="$(tc-getCXX)" emake PREFIX=/usr || die
}

src_install() {
	make DESTDIR="${D}" PREFIX=/usr install || die

	dodoc ../AUTHORS

	if use doc ; then
		cd ../doc
		dohtml -r *
	fi
}
