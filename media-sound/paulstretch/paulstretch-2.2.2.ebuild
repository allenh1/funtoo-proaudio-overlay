# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs git-r3

RESTRICT="mirror"
DESCRIPTION="extreme sound stretching of the audio"
HOMEPAGE="http://hypermammut.sourceforge.net/paulstretch"

EGIT_REPO_URI="https://github.com/paulnasca/paulstretch_cpp.git"
EGIT_COMMIT="7f5c399"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE="fftw jack"
DEPEND="dev-libs/mini-xml
		media-libs/libmad
		media-libs/libvorbis
		media-libs/portaudio
		media-libs/audiofile
		>=x11-libs/fltk-1.1.7
		fftw? ( =sci-libs/fftw-3* )
		jack? (
			media-sound/jack-audio-connection-kit
			=sci-libs/fftw-3*
			)"
RDEPEND="${DEPEND}"

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
