# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils
# qt4-r2

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="ftp://bpmdj.yellowcouch.org/${PN}/${PN}-v4.2-pl4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="vorbis"

DEPEND="${RDEPEND}
	dev-qt/qtcore
	dev-qt/qtgui
	virtual/pkgconfig"

RDEPEND="media-libs/alsa-lib
	 vorbis? ( media-sound/vorbis-tools )
	 media-sound/jack-audio-connection-kit
	 =sci-libs/fftw-3*"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die "cd failed"

	# copy gentoo defines
	cp defines.gentoo defines || die "defines failed"

	# add QtCore to QT_LIBS
	echo "QT_LIBS = -lQtGui -lQtCore" >> defines

	# not to forget our custom C(XX)FLAGS
	echo "CPP             = g++ -g ${CXXFLAGS} -Wall" >> defines
}

src_compile() {
	make || die "make failed"
}

src_install () {
	# makefile is absolutly a mess so we use portage features
	for i in authors changelog copyright readme support; do
		mv ${i}.txt ${i}; dodoc ${i}; done
	dodir /usr/$(get_libdir)/${PN}
	exeinto /usr/$(get_libdir)/${PN}
	doexe bpmcount bpmdj bpmdjraw bpmmerge bpmplay
	# needed too..
	mv sequences "${D}/usr/$(get_libdir)/${PN}"
	#dodoc authors changelog readme support.txt
	# install startup wrapper
	dobin "${FILESDIR}/${PN}.sh"
	# install logo and desktop entry
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry "bpmdj.sh" "BpmDj" ${PN} "AudioVideo;Audio"
}
