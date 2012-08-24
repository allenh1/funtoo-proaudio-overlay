# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="ftp://bpmdj.yellowcouch.org/${PN}/${P}.source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="alsa jack vorbis"

DEPEND="${RDEPEND}
	|| ( ( x11-libs/qt-core x11-libs/qt-gui )
			>=x11-libs/qt-4.2:4 )
	dev-util/pkgconfig"

RDEPEND="alsa? ( media-libs/alsa-lib )
	 vorbis? ( media-sound/vorbis-tools )
	 jack? ( media-sound/jack-audio-connection-kit )
	 =sci-libs/fftw-3*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# add our defines
	cp "${FILESDIR}/${PN}-3-defines.gentoo" defines

	epatch "${FILESDIR}/${P}-include.patch"

	# and now.. the useflags. What a giant PITA!
	# Note: oss could be optional, but compile fails if disabled!
	local flags=""
	flags="CFLAGS         += -D QT_THREAD_SUPPORT -D QT3_SUPPORT"
	use alsa && flags="${flags} -D COMPILE_ALSA"
	use jack && flags="${flags} -D COMPILE_JACK"
	echo "${flags} -D COMPILE_OSS -D NO_EMPTY_ARRAYS -fPIC" >> defines

	# and the same for LDFLAGS..
	local lflags=""
	lflags="LDFLAGS        += -lpthread -lm -lrt -lfftw3"
	use alsa && lflags="${lflags} -lasound"
	use jack && lflags="${lflags} -ljack"
	echo "${lflags}" >> defines

	# not to forget our custom C(XX)FLAGS
	echo "CPP             = g++ -g ${CXXFLAGS} -Wall" >> defines
}

src_compile() {
	make || die "make failed"
}

src_install () {
	mv support.txt support
	# makefile is absolutly a mess so we use portage features
	dodoc authors changelog copyright readme todo support
	dodir /usr/$(get_libdir)/${PN}
	exeinto /usr/$(get_libdir)/${PN}
	doexe bpmcount bpmdj bpmdjraw bpmmerge bpmplay
	# needed too..
	mv sequences "${D}/usr/$(get_libdir)/${PN}"
	# install startup wrapper
	dobin "${FILESDIR}/${PN}.sh"
	# install logo and desktop entry
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry "bpmdj.sh" "BpmDj" ${PN} "AudioVideo;Audio"
}
