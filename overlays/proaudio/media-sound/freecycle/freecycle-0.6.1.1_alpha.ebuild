# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: this ebuild needs some kde/qt3 eclass work -- will not function
inherit eutils # qt3

MY_P="${P/_alpha/alpha}"

RESTRICT="mirror"
DESCRIPTION="Freecycle is a beat slicer"
HOMEPAGE="http://www.redsteamrecords.com/freecycle/"
SRC_URI="http://download.savannah.gnu.org/releases/freecycle/${MY_P}.tar.bz2
		doc? ( http://download.savannah.gnu.org/releases/freecycle/freecycle-manual-1.0.0.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"

IUSE="doc oss jack portaudio"

DEPEND="=sci-libs/fftw-3*
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	>=media-libs/aubio-0.2
	=x11-libs/qt-3*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	QTDIR="/usr/qt/3"
	# configure features
	sed -i 's|DEFINES += HAS_PORTMIDI|#DEFINES += HAS_PORTMIDI|g' src/cond.pri
	use !portaudio && sed -i 's|DEFINES += HAS_PORTAUDIO|#DEFINES += HAS_PORTAUDIO|g' src/cond.pri
	use !oss && sed -i 's|DEFINES += HAS_OSS|#DEFINES += HAS_OSS|g' src/cond.pri
	sed -i 's|DEFINES += HAS_LIBINSTPATCH|#DEFINES += HAS_LIBINSTPATCH|g' src/cond.pri
	#sed -i 's|DEFINES += HAS_SOUNDTOUCH|#DEFINES += HAS_SOUNDTOUCH|g' src/cond.pri
	use !oss && sed -i 's|DEFINES += HAS_OSS|#DEFINES += HAS_OSS|g' src/cond.pri
	echo "QMAKE = ${QTDIR}/bin/qmake" >> freecycle.pro

	 ${QTDIR}/bin/qmake freecycle.pro

	emake || die "emake failed"
}

src_install() {
	dobin "${S}"/bin/freecycle
	dodoc README TODOS
	if use doc; then
		dohtml "${WORKDIR}"/doc/*
	fi
}
