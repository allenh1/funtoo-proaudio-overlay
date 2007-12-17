# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="http://www.sonicvisualiser.org/"
SRC_URI="mirror://sourceforge/sv1/${P}-source.tar.bz2
	mirror://sourceforge/sv1/vamp-plugin-sdk-0.9.1.tar.bz2
	mirror://sourceforge/sv1/vamp-aubio-plugins-0.3.0-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="jack mad ogg portaudio O3"

DEPEND="$(qt4_min_version 4)
	media-libs/libsndfile
	media-libs/libsamplerate
	>=media-libs/aubio-0.3.0
	>=sci-libs/fftw-3.0
	app-arch/bzip2
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( =media-libs/portaudio-18* )
	mad? ( media-libs/libmad )
	ogg? ( media-libs/libfishsound )"

S="${WORKDIR}/${PN}"
S_V="${WORKDIR}/vamp-plugin-sdk"
S_A="${WORKDIR}/vamp-aubio-plugins"

src_unpack() {
	unpack ${A}
	# sonic configuration
	cd ${S}
	use O3 && local c_flag="-O3 -mfpmath=sse -fomit-frame-pointer"
	sed -i \
	-e "s~-DNDEBUG -O2 -march=pentium3~${c_flag}~" \
	sonic-visualiser.pro || die "Sed failed"

	if ! use portaudio ; then
	    sed -i \
	    -e 's~DEFINES += HAVE_PORTAUDIO~#DEFINES += HAVE_PORTAUDIO~' \
	    -e 's~LIBS    += -lportaudio~#LIBS~' \
	    sonic-visualiser.pro || die "Portaudio remove failed"
	fi
	#gcc 4 fixes
	sed -i -e 's@DirectoryCreationFailed::\(~DirectoryCreationFailed()\)@\1@g' \
		base/TempDirectory.h
	sed -i -e 's@MIDIException::\(~MIDIException()\)@\1@g' \
		fileio/MIDIFileReader.cpp

}

src_compile() {
	# vamp-sdk
	cd ${S_V}
	emake || die "vamp-sdk compilation failed"
	# aubio-plugins
	cd ${S_A}
	emake || die "Aubio-plugins compilation failed"
	# sonic v
	cd ${S}
	qmake || die "Configuration failed"
	make || die "Compilation failed"
}

src_install() {
	dobin sonic-visualiser || die "Binaries installation failed"
	dodoc COPYING README TODO || die "Doc installation failed"
	insinto /usr/share/${PN}/samples
	doins samples/* || die "Samples installation failed"
	#install plugins
	insinto /usr/lib/vamp
	doins ${S_V}/examples/*.so
	doins ${S_A}/*.so
}
