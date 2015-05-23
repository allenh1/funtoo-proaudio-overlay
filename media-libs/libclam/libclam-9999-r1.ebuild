# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit subversion eutils python qt4-r2

DESCRIPTION="Framework for research and application development in the Audio and Music domain"
HOMEPAGE="http://clam-project.org/index.html"

MY_PN="CLAM"

SRC_URI=""
ESVN_REPO_URI="http://clam-project.org/clam/trunk"
ESVN_PROJECT="clam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc double fft fftw jack ladspa lv2 mad optimize osc portaudio portmidi rtaudio sndfile vorbis xercesc +xmlpp"
RESTRICT="mirror"

PYTHON_DEPEND="2:7"
RDEPEND="ladspa? ( media-libs/ladspa-sdk )
	xercesc? ( >=dev-libs/xerces-c-2.7[icu] )
	xmlpp? ( dev-cpp/libxmlpp:2.6 )
	fftw? ( =sci-libs/fftw-3* )
	virtual/opengl
	x11-libs/fltk
	jack? ( media-sound/jack-audio-connection-kit )
	vorbis? ( media-libs/libvorbis
	    media-libs/libogg )
	mad? ( media-libs/libmad
		media-libs/id3lib )
	sndfile? ( media-libs/libsndfile )
	portaudio? ( =media-libs/portaudio-19* )
	portmidi? ( media-libs/portmidi )
	virtual/jpeg
	lv2? ( media-libs/slv2 )
	rtaudio? ( media-libs/alsa-lib )
	media-libs/libpng
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXi
	dev-qt/qtgui:4
	dev-util/cppunit
	osc? ( media-libs/oscpack )"

DEPEND="${DEPEND}
	dev-util/scons
	app-doc/doxygen"

S="${WORKDIR}/${MY_PN}"
MY_S="${S}/${MY_PN}"

pkg_setup() {
	python_set_active_version 2
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	cd "${MY_S}" || die
	epatch "${FILESDIR}/${P}_timeutc.patch"
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr

	cd "${MY_S}" || die

	local myconf="DESTDIR=${D}/usr prefix=/usr prefix_for_packaging=${D}/usr"
	if use double; then
	    myconf="${myconf} double=yes"
	fi
	if use optimize; then
	    myconf="${myconf} optimize_and_lise_precision=yes"
	fi
	if use xercesc; then
		if use xmlpp; then
			myconf+=" xmlbackend=both"
		else
			myconf+=" xmlbackend=xercesc"
		fi
	else
		if use xmlpp; then
			myconf+=" xmlbackend=xmlpp"
		else
			myconf>=" xmlbackend=none"
		fi
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
	if ! use lv2; then
	    myconf="${myconf} with_lv2=no"
	fi
	if ! use fftw; then
	    myconf="${myconf} with_fftw3=no"
	    else
		myconf="${myconf} with_fftw3=yes"
	fi
	if ! use fft; then
	    myconf="${myconf} with_nr_fftw=no"
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
	if use mad; then # was ! use id3
	    myconf="${myconf} with_mad=yes"
	    myconf="${myconf} with_id3=yes" # was no
	fi
	if ! use portaudio; then
	    myconf="${myconf} with_portaudio=no"
	fi
	if ! use rtaudio; then
	    myconf="${myconf} audio_backend=portaudio"
	else
	    myconf="${myconf} audio_backend=rtaudio"
	fi
	if ! use portmidi; then
	    myconf="${myconf} with_portmidi=no"
	fi
	scons configure ${myconf} || die "configuration failed"
	scons --help configure
	scons || die "compilation failed"
}

src_install() {
	cd "${MY_S}" || die
	dodir /usr

	scons install || die "scons install failed"
	cd "${MY_S}"
	dodoc CHANGES

	if use doc; then
		docinto examples/CLAMRemoteController
		dodoc "${MY_S}"/examples/CLAMRemoteController/*
		docinto examples/CLT
		dodoc "${MY_S}"/examples/CLT/*
		docinto examples/ControlArrayExamples
		dodoc "${MY_S}"/examples/ControlArrayExamples/*
		docinto examples/MIDI_Synthesizer_example
		dodoc "${MY_S}"/examples/MIDI_Synthesizer_example/*
		docinto examples/NetworkLADSPAPlugin
		dodoc "${MY_S}"/examples/NetworkLADSPAPlugin/*
		docinto examples/PortsAndControlsUsageExample
		dodoc "${MY_S}"/examples/PortsAndControlsUsageExample/*
		docinto examples/PortsExamples
		dodoc "${MY_S}"/examples/PortsExamples/*
#		docinto examples/QtDesignerPlugins
#		dodoc "${S}"/examples/QtDesignerPlugins/*
		docinto examples/QtPlots/BPFEditorExample
		dodoc "${MY_S}"/examples/QtPlots/BPFEditorExample/*
		docinto examples/QtPlots/DirectPlotsExamples
		dodoc "${MY_S}"/examples/QtPlots/DirectPlotsExamples/*
		docinto examples/QtPlots/ListPlotExample
		dodoc "${MY_S}"/examples/QtPlots/ListPlotExample/*
		docinto examples/QtPlots/QtPlotsExamples
		dodoc "${MY_S}"/examples/QtPlots/QtPlotsExamples/*
		docinto examples/QtPlots/SegmentEditorExample
		dodoc "${MY_S}"/examples/QtPlots/SegmentEditorExample/*
		docinto examples/QtPlots/utils
		dodoc "${MY_S}"/examples/QtPlots/utils/*
		docinto examples/Tutorial
		dodoc "${MY_S}"/examples/Tutorial/*
	fi
}
