# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="extreme sound stretching of the audio"
HOMEPAGE="http://hypermammut.sourceforge.net/paulstretch"

MY_P="${PN}-2.2-2"
SRC_URI="mirror://sourceforge/hypermammut/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE="fftw jack"
DEPEND="media-libs/portaudio
		media-libs/audiofile
		>=x11-libs/fltk-1.1.7
		fftw? ( =sci-libs/fftw-3* )
		jack? (
			media-sound/jack-audio-connection-kit
			=sci-libs/fftw-3*
			)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-2.2-2"

src_prepare() {
	epatch "${FILESDIR}/fix-mp3inputs.patch"
}

src_compile() {
	if ! use jack; then
		if use fftw; then
			sed -i -e "s:g++ -ggdb:$(tc-getCXX) ${CFLAGS} ${LDFLAGS}:" \
				compile_linux_fftw.sh || die "sed fix failed"
		else
			sed -i -e "s:g++ -ggdb:$(tc-getCXX) ${CFLAGS} ${LDFLAGS}:" \
				compile_linux_kissfft.sh || die "sed fix failed"
		fi
	else
		sed -i -e "s:g++ -ggdb:$(tc-getCXX) ${CFLAGS} ${LDFLAGS}:" \
			compile_linux_fftw_jack.sh || die "sed fix failed"
	fi
#	outfile=paulstretch
#	fluid -c GUI.fl || die "generate gui failed"
	if ! use jack; then
		if use fftw ;then
			./compile_linux_fftw.sh || die "compilation failed"
		else
			./compile_linux_kissfft.sh || die "compilation failed"
		fi
	else
		./compile_linux_fftw_jack.sh || die "compilation failed"
	fi
}

src_install() {
	dobin paulstretch
	dodoc readme.txt
}
