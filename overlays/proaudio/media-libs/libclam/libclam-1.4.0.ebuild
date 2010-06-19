# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="Framework for research and application development in the Audio and Music domain"
HOMEPAGE="http://clam-project.org/"

MY_PN="CLAM"
MY_P="CLAM-${PV}"

SRC_URI="http://clam-project.org/download/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc double jack ladspa osc fftw fft alsa optimize sndfile vorbis mad portaudio"
# portmidi"

RESTRICT="mirror"

DEPEND=">=dev-util/scons-0.96.92
	ladspa? ( media-libs/ladspa-sdk )
	=dev-libs/xerces-c-2.8*
	fftw? ( =sci-libs/fftw-3* )
	virtual/opengl
	x11-libs/fltk
	jack? ( media-sound/jack-audio-connection-kit )
	vorbis? ( media-libs/libvorbis
	    media-libs/libogg )
	mad? ( media-libs/libmad )
	sndfile? ( media-libs/libsndfile )
	mad? ( media-libs/id3lib )
	portaudio? ( =media-libs/portaudio-19* )
	media-libs/jpeg
	alsa? ( media-libs/alsa-lib )
	media-libs/libpng
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXi
	|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-opengl )
			>=x11-libs/qt-4.4:4 )
	app-doc/doxygen
	dev-util/cppunit
	osc? ( media-libs/oscpack )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr

	cd "${S}"

	local myconf="DESTDIR=${D}/usr prefix=/usr prefix_for_packaging=${D}/usr"
	if use double; then
	    myconf="${myconf} double=yes"
	fi
	if use optimize; then
	    myconf="${myconf} optimize_and_lose_precision=yes"
	fi
	if ! use ladspa; then
	    myconf="${myconf} with_ladspa=no"
	fi
	if use osc; then
	    myconf="${myconf} with_osc=yes"
	fi
	if ! use jack; then
	    myconf="${myconf} with_jack=no"
	fi
	if ! use fftw; then
	    myconf="${myconf} with_fftw=no"
	    else
		myconf="${myconf} with_fftw=no with_fftw3=yes"
	fi
	if ! use fft; then
	    myconf="${myconf} with_nr_fft=no"
	fi
	if ! use sndfile; then
	    myconf="${myconf} with_sndfile=no"
	fi
	if ! use vorbis; then
	    myconf="${myconf} with_oggvorbis=no"
	fi
	if ! use mad; then
	    myconf="${myconf} with_mad=no"
	    myconf="${myconf} with_id3=no" # workaround buggy buildsys
	fi
	if  use mad; then # was ! use id3 workaround buggy buildsys
	    myconf="${myconf} with_mad=yes"
	    myconf="${myconf} with_id3=yes" # was no
	fi
	if ! use portaudio; then
	    myconf="${myconf} with_portaudio=no"
	fi
	if ! use alsa; then
	    myconf="${myconf} with_alsa=no"
	fi
	scons configure ${myconf} || die "configuration failed"
	scons --help
	scons || die "compilation failed"
}

src_install() {
	dodir /usr

	scons install || die "scons install failed"
	dodoc CHANGES

	if use doc; then
		docinto examples/ConfiguratorExample
		dodoc "${S}"/examples/ConfiguratorExample/*
		docinto examples/ControlArrayExamples
		dodoc "${S}"/examples/ControlArrayExamples/*
		docinto examples/FormantTracking
		dodoc "${S}"/examples/FormantTracking/*
		docinto examples/LadspaOSCRemoteController
		dodoc "${S}"/examples/LadspaOSCRemoteController/*
		docinto examples/NetworkLADSPAPlugin
		dodoc "${S}"/examples/NetworkLADSPAPlugin/*
		docinto examples/PluginExample
		dodoc "${S}"/examples/PluginExample/*
		docinto examples/PortsAndControlsUsageExample
		dodoc "${S}"/examples/PortsAndControlsUsageExample/*
		docinto examples/ProcessingClass2Ladspa
		dodoc "${S}"/examples/ProcessingClass2Ladspa/*
		docinto examples/SDIF2Wav
		dodoc "${S}"/examples/SDIF2Wav/*
		docinto examples/SDIF2WavStreaming
		dodoc "${S}"/examples/SDIF2WavStreaming/*
		docinto examples/SDIFToWavStreaming
		dodoc "${S}"/examples/SDIFToWavStreaming/*
		docinto examples/TickExtractor
		dodoc "${S}"/examples/TickExtractor/*
		docinto examples/Tutorial
		dodoc "${S}"/examples/Tutorial/*
		docinto examples/Wav2SDIF
		dodoc "${S}"/examples/Wav2SDIF/*
		docinto examples/loopMaker
		dodoc "${S}"/examples/loopMaker/*
		docinto examples
		dodoc "${S}"/examples/*
	fi
}
