# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Csound is a sound and music synthesis system, providing facilities for composition and performance over a wide range of platforms."

HOMEPAGE="http://csounds.com"

RESTRICT="nomirror"
MY_P=${P/csound-/Csound}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# We default to using alsa, so no useflag for it ;)
IUSE="debug dssi gui java jack portaudio stk_opcodes osc_opcodes expensive_math doc amd64 ppc64 static altivec"


RDEPEND="media-libs/ladspa-sdk
	media-libs/alsa-lib
	>=media-libs/libsndfile-1.0.16"

DEPEND="${RDEPEND}
	>=x11-libs/fltk-1.1.7
	dev-util/scons
	=dev-lang/python-2.4*
	dev-lang/swig
	dev-lang/lua
	portaudio? ( =media-libs/portaudio-19* )
	jack? ( media-sound/jack-audio-connection-kit )
	java? ( virtual/jdk )
	osc_opcodes? ( media-libs/liblo )
	doc? ( app-doc/doxygen )
	dssi? ( >=media-libs/dssi-0.9.1 )"
	#broken
	#csoundvst? ( >=dev-libs/boost-1.32.1 )
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-SConsruct.diff"
}

src_compile() {

	cp "${FILESDIR}/custom.py" .

	! use dssi; myconf="${myconf} buildDSSI=$?"
	! use expensive_math; myconf="${myconf} useDouble=$?"
	! use portaudio; myconf="${myconf} usePortAudio=$?"
	! use jack; myconf="${myconf} useJack=$?"
	#! use csoundvst; myconf="${myconf} buildCsoundVST=$? buildCsound5GUI=$?"
	! use gui; myconf="${myconf} buildCsound5GUI=$?"
	! use doc; myconf="${myconf} generatePdf=$?"
	! use static; myconf="${myconf} dynamicCsoundLibrary=$?"
	! use osc_opcodes; myconf="${myconf} useOSC=$?"
	! use stk_opcodes; myconf="${myconf} buildStkOpcodes=$?"
	! use java; myconf="${myconf} buildJavaWrapper=$?"
	! use altivec; myconf="${myconf} useAltivec=$?"
	! use debug; myconf="${myconf} buildRelease=$?"
	( use amd64 || use ppc64 )  && myconf="${myconf} Word64=1"

	# These addpredicts are to stop sandbox violation errors
	# addpredict in src_compile() alone does not stop sandbox
	# violation errors in src_install(()
	addpredict "/usr/include"
	addpredict "/usr/lib"

	einfo "You enabled following scons options: ${myconf}"
	
	scons \
		prefix=/usr \
		CC=/usr/bin/gcc \
		customCCFLAGS="$CFLAGS -fno-strict-aliasing -D_LINUX_IF_H" \
		customCXXFLAGS="$CXXFLAGS -fno-strict-aliasing -D_LINUX_IF_H" \
		dynamicCsoundLibrary=0 \
		useCoreAudio=0 \
		buildLoris=1 \
		pythonVersion=2.4 \
		buildPythonOpcodes=0\
		useFluidsynth=1 \
		useALSA=1 \
		${myconf} || die "scons failed!"
}

src_install() {
#	addpredict "/usr/include"
#	dodir "/usr/bin"
#	scons prefix=${D}/usr install || die "scons install failed!"
	./install.py --prefix="/usr/" --instdir="${D}"
	cd ${D}/usr
	rm -f *.md5sums
}

