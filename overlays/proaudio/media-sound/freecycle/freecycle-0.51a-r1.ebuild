# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/freecycle/freecycle-0.51a-r1.ebuild,v 1.1.1.1 2006/04/10 10:26:49 gimpel Exp $

inherit eutils qt3 kde-functions

RESTRICT="nomirror"
MY_P=${P/a/alpha}
DESCRIPTION="Freecycle is a beat slicer"
HOMEPAGE="http://www.redsteamrecords.com/freecycle/"
SRC_URI="http://download.savannah.gnu.org/releases/freecycle/${MY_P}.tar.bz2
		doc? ( http://download.savannah.gnu.org/releases/freecycle/freecycle-manual-1.0.0.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE="doc oss jack portaudio"

DEPEND=">=x11-libs/qt-3
	=sci-libs/fftw-3*
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	>=media-libs/aubio-0.2
	=x11-libs/qt-3*"
	# >=dev-libs/libinstpatch-1.0.0_pre1
#	portaudio? ( media-libs/portaudio )"

S="${WORKDIR}/${PN}"

need-qt 3

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
	 # -spec /usr/qt/3/mkspecs/linux-g++/ -cache /usr/qt/3/.qmake.cache
	 # HINT
	 # find -iname '*pro' find -iname '*pri' # set settings
	 # qmake freecycle.pro || die "qmake failed"
	  emake || die "emake failed"
}

src_install() {
	dobin "${S}"/bin/freecycle
	dodoc README TODOS
	if use doc; then
		dohtml "${WORKDIR}"/doc/*
	fi
}
