# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 flag-o-matic

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="http://www.sonicvisualiser.org/"
SRC_URI="mirror://sourceforge/sv1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="jack mad ogg portaudio"

RDEPEND="$(qt4_min_version 4.2)
	media-libs/libsndfile
	media-libs/libsamplerate
	>=sci-libs/fftw-3.0
	app-arch/bzip2
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( =media-libs/portaudio-19* )
	mad? ( media-libs/libmad )
	ogg? ( media-libs/libfishsound )"
DEPEND="${RDEPEND}
		>=dev-libs/vamp-plugin-sdk-1.0
		>=dev-util/pkgconfig-0.9"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# portaudio
	if ! use portaudio; then
		sed -i -e "s:DEFINES += HAVE_PORTAUDIO:#DEFINES += HAVE_PORTAUDIO:" \
			-e "s:LIBS    += -lportaudio:#LIBS    += -lportaudio:" \
			sv.prf
	fi
	# remove crap
	sed -i -e "s:-O2 -march=pentium3 -mfpmath=sse::" sv.prf
}

src_compile() {
	cd ${S}
	# don't use ffast-math
	filter-flags "-ffast-math"
	/usr/bin/qmake || die "Configuration failed"
	make || die "Compilation failed"
}

src_install() {
	dobin sv/sonic-visualiser
	dodoc README README.OSC
	dodir /usr/share/${PN}
	#install samples
	insinto /usr/share/${PN}/samples
	doins sv/samples/*
}

pkg_postinst() {
	elog ""
	elog "You might also want to install some Vamp plugins."
	elog "See media-plugins/vamp-*"
	elog ""
}

