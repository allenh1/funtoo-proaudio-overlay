# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
#scons-ccache

DESCRIPTION="Framework for research and application development in the Audio and Music domain"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

MY_PN="CLAM"
MY_P="CLAM-${PV}"

SRC_URI="http://clam.iua.upf.edu/download/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc double jack ladspa osc fftw fft alsa qt3 sndfile vorbis mad id3 portaudio"
RESTRICT="nomirror"

DEPEND="dev-util/scons
	ladspa? ( media-libs/ladspa-sdk )
	>=dev-libs/xerces-c-2.7
	fftw? ( =sci-libs/fftw-2* )
	virtual/opengl
	x11-libs/fltk
	jack? ( media-sound/jack-audio-connection-kit )
	vorbis? ( media-libs/libvorbis
	    media-libs/libogg )
	mad? ( media-libs/libmad )
	sndfile? ( media-libs/libsndfile )
	id3? ( media-libs/id3lib )
	portaudio? ( =media-libs/portaudio-19* )
	media-libs/jpeg
	alsa? ( media-libs/alsa-lib )
	media-libs/libpng
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXi
	qt3? ( =x11-libs/qt-3* )
	app-doc/doxygen
	dev-util/cppunit
	osc? ( media-libs/oscpack )"
	
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/oscthread-fix.patch || die "epatch failed"
		
#	cd ${S}/scons/libs
#	add_ccache_to_scons_v2 || die "add cache to scons failed"
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	    
	cd ${S}/scons/libs
	
	local myconf="DESTDIR=${D}/usr prefix=/usr install_prefix=${D}/usr"
	if use double; then
	    myconf="${myconf} double=yes"
	fi
	if ! use ladspa; then
	    myconf="${myconf} with_ladspa_support=no"
	fi
	if use osc; then
	    myconf="${myconf} with_osc_support=yes"
	fi
	if ! use jack; then
	    myconf="${myconf} with_jack_support=no"
	fi
	if ! use fftw; then
	    myconf="${myconf} with_fftw=no"
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
	fi
	if ! use id3; then
	    myconf="${myconf} with_id3=no"
	fi
	if use portaudio; then
	    myconf="${myconf} with_portaudio=yes"
	fi
	if ! use alsa; then
	    myconf="${myconf} with_alsa=no"
	fi
	scons configure ${myconf} || die "configuration failed"
	scons --help configure
	scons || die "compilation failed"
}

src_install() {
	cd ${S}/scons/libs
	dodir /usr
	
	scons install || die "scons install failed"
	cd ${S}
	dodoc CHANGES
	
	if use doc; then
		docinto examples/CLAMRemoteController
		dodoc ${S}/examples/CLAMRemoteController/*
		docinto examples/CLT
		dodoc ${S}/examples/CLT/*
		docinto examples/ControlArrayExamples
		dodoc ${S}/examples/ControlArrayExamples/*
		docinto examples/MIDI_Synthesizer_example
		dodoc ${S}/examples/MIDI_Synthesizer_example/*
		docinto examples/NetworkLADSPAPlugin
		dodoc ${S}/examples/NetworkLADSPAPlugin/*
		docinto examples/PortsAndControlsUsageExample
		dodoc ${S}/examples/PortsAndControlsUsageExample/*
		docinto examples/PortsExamples
		dodoc ${S}/examples/PortsExamples/*
		docinto examples/QtDesignerPlugins
		dodoc ${S}/examples/QtDesignerPlugins/*
		docinto examples/QtPlots/BPFEditorExample
		dodoc ${S}/examples/QtPlots/BPFEditorExample/*
		docinto examples/QtPlots/DirectPlotsExamples
		dodoc ${S}/examples/QtPlots/DirectPlotsExamples/*
		docinto examples/QtPlots/ListPlotExample
		dodoc ${S}/examples/QtPlots/ListPlotExample/*
		docinto examples/QtPlots/QtPlotsExamples
		dodoc ${S}/examples/QtPlots/QtPlotsExamples/*
		docinto examples/QtPlots/SegmentEditorExample
		dodoc ${S}/examples/QtPlots/SegmentEditorExample/*
		docinto examples/QtPlots/utils
		dodoc ${S}/examples/QtPlots/utils/*
		docinto examples/Tutorial
		dodoc ${S}/examples/Tutorial/*
	fi
}
