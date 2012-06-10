# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2"

inherit exteutils python eutils toolchain-funcs

MY_P=${P/csound-/Csound}
MY_PV=${PV/12.1/12}
STK_VERSION="4.4.2"

DESCRIPTION="Csound is a sound and music synthesis system, providing facilities for composition and performance"
HOMEPAGE="http://csound.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
doc? ( mirror://sourceforge/${PN}/Csound${MY_PV}_manual_html.zip )
stk? ( http://ccrma.stanford.edu/software/stk/release/stk-${STK_VERSION}.tar.gz )
vst? ( vstsdk2_4_rev1.zip )
vst-host? ( vstsdk2_4_rev1.zip )"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="+alsa altivec amd64 ppc64 csoundac -doc +double-precision +nodebug dssi editor examples fluidsynth gui htmldoc jack java loris lua mp3 musicxml newparser osc p5glove pd +python -portaudio +static stk tcl vst -vst-host wiimote"

RDEPEND="media-libs/ladspa-sdk
	alsa? ( media-libs/alsa-lib )
	csoundac? ( x11-libs/fltk:1[threads]
		dev-libs/boost
		dev-lang/swig )
	dssi? ( media-libs/dssi
		media-libs/ladspa-sdk )
	>=media-libs/libsndfile-1.0.16
	editor? ( x11-libs/fltk:1[threads] )
	fluidsynth? ( media-sound/fluidsynth )
	gui? ( x11-libs/fltk:1[threads] )
	htmldoc? ( =app-doc/csound-htmldoc-meta-5.12 )
	jack? ( media-sound/jack-audio-connection-kit )
	java? ( || ( virtual/jre virtual/jdk ) )
	loris? ( media-libs/loris[csound,fftw] )
	lua? ( dev-lang/lua )
	mp3? ( media-sound/mpadec )
	musicxml? ( media-libs/libmusicxml:2 )
	osc? ( media-libs/liblo )
	p5glove? ( media-libs/libp5glove )
	pd? ( virtual/pd )
	stk? ( =media-libs/stk-${STK_VERSION} )
	tcl? ( >=dev-lang/tcl-8.5
		>=dev-lang/tk-8.5 )
	wiimote? ( media-libs/wiiuse )"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/pkgconfig
	dev-util/scons
	>=dev-lang/python-2.4
	portaudio? ( =media-libs/portaudio-19* )
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2

	if use pd; then
		ewarn "You have enabled pd (PureData) use-flag."
		ewarn "Please abort the build with CTRL-C, and install"
		ewarn "\"pd-overlay\" with layman ...unless you have done"
		ewarn "it already."
		ewarn
		epause 5
	fi

	if use vst; then
		if ! use csoundac || ! use gui; then
			eerror "Please set USE=\"csoundac gui\" with vst use-flag!"
			die
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/install-stk.patch
	epatch "${FILESDIR}"/javaVM.patch
	epatch "${FILESDIR}"/libmusicxml.patch
	epatch "${FILESDIR}"/custom.py-${PV}.patch

	if use csoundac && ! use lua ; then
		die "You have enables the USE csoundac, you must emerge ${P} with USE=\"lua\" for this to work"
	fi

	if use stk; then
		ebegin "Copying Perry Cook's Synthesis ToolKit to the tree"
		cp -r "${WORKDIR}"/stk-"${STK_VERSION}"/* "${S}"/Opcodes/stk/
		eend
	fi

	if use vst || use vst-host; then
		ebegin "Copying Steinberg's VST SDK to the tree"
		cp -r "${WORKDIR}"/vstsdk2.4 "${S}"/frontends/CsoundVST/
		eend
	fi
}

src_compile() {
	local sconsconf="prefix=/usr \
		pythonVersion=$(python_get_version) \
		tclversion=8.5 \
		usePortAudio=0 \
		usePortMIDI=0 \
		useCoreAudio=0 \
		buildUtilities=1 \
		buildInterfaces=1"
	if use amd64; then
		sconsconf="${sconsconf} Word64=1 Lib64=1"
	fi
	! use alsa; sconsconf="${sconsconf} useALSA=$?"
	! use altivec; sconsconf="${sconsconf} useAltivec=$?"
	! use csoundac; sconsconf="${sconsconf} buildCsoundAC=$?"
	! use nodebug; sconsconf="${sconsconf} buildRelease=$?"
	# Pdf generation is totally broken, so it is disabled by default
	! use doc; sconsconf="${sconsconf} generatePdf=$?"
	! use double-precision; sconsconf="${sconsconf} useDouble=$?"
	! use dssi; sconsconf="${sconsconf} buildDSSI=$?"
	! use editor; sconsconf="${sconsconf} useFLTK=$? buildCSEditor=$?"
	! use gui; sconsconf="${sconsconf} useFLTK=$? buildCsound5GUI=$? buildVirtual=$?"
	! use jack; sconsconf="${sconsconf} useJack=$?"
	! use java; sconsconf="${sconsconf} buildJavaWrapper=$?"
	# Handled by the media-libs/loris package
	#! use loris; sconsconf="${sconsconf} buildLoris=$?"
	! use lua; sconsconf="${sconsconf} buildLuaWrapper=$?"
	! use mp3; sconsconf="${sconsconf} includeMP3=$?"
	! use newparser; sconsconf="${sconsconf} buildNewParser=$?"
	! use osc; sconsconf="${sconsconf} useOSC=$?"
	! use p5glove; sconsconf="${sconsconf} includeP5Glove=$?"
	! use pd; sconsconf="${sconsconf} buildPDClass=$?"
# Pdf generation is totally broken, so it is disabled by default
	! use doc; sconsconf="${sconsconf} generatePdf=$?"
	! use double-precision; sconsconf="${sconsconf} useDouble=$?"
	! use dssi; sconsconf="${sconsconf} buildDSSI=$?"
	! use editor; sconsconf="${sconsconf} useFLTK=$? buildCSEditor=$?"
	! use gui; sconsconf="${sconsconf} useFLTK=$? buildCsound5GUI=$? buildVirtual=$?"
# Portaudio is broken, so it is disabled by default
	! use portaudio; sconsconf="${sconsconf} usePortAudio=$?"
	! use python; sconsconf="${sconsconf} buildPythonOpcodes=$? buildPythonWrapper=$?"
	! use static; sconsconf="${sconsconf} dynamicCsoundLibrary=$?"
	! use stk; sconsconf="${sconsconf} buildStkOpcodes=$?"
	! use tcl; sconsconf="${sconsconf} buildTclcsound=$?"
	! use vst; sconsconf="${sconsconf} buildCsoundVST=$?"
	! use vst-host; sconsconf="${sconsconf} buildvst4cs=$?"
	! use wiimote; sconsconf="${sconsconf} includeWii=$?"

	einfo "Building Csound with the following configuration options:"
	einfo ${sconsconf}
	epause 5

	# These addpredicts are to stop sandbox violation errors
	# addpredict in src_compile() alone does not stop sandbox
	# violation errors in src_install(()
	addpredict "/usr/include"
	addpredict "/usr/lib"
	addpredict "/etc/ld.so.cache"

	einfo "You enabled following scons options: ${myconf}"

	escons \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		customCCFLAGS="$CFLAGS -fno-strict-aliasing" \
		customCXXFLAGS="$CXXFLAGS -fno-strict-aliasing" \
		${sconsconf} || die "scons failed!"
}

src_install() {
	if use amd64; then
		./install.py --prefix="/usr" --instdir="${D}" --word64
	else
		./install.py --prefix="/usr" --instdir="${D}"
	fi
	# Post-installation fixes (probably should patch install.py instead, but...)
	rm -rf "${D}"/usr/*.md5sums
	rm -rf "${D}"/usr/share/doc/csound
	rm -rf "${D}"/usr/bin/uninstall-csound5
	cd "${D}"/usr/$(get_libdir)
	ln -s libcsnd.so.5.2 libcsnd.so
	cd "${S}"
	if use csoundac; then
		insinto $(python_get_sitedir)
		doins CsoundAC.py
		insopts -m0755
		doins _CsoundAC.so
		if use lua; then
			insinto /usr/$(get_libdir)/csound/lua
			doins luaCsoundAC.so
		fi
		insopts -m0644
	fi
	if use lua; then
		insinto /usr/$(get_libdir)/csound/lua
		insopts -m0755
		doins luaCsnd.so
		insopts -m0644
	fi

	if use double-precision; then
		echo "OPCODEDIR64=/usr/$(get_libdir)/csound/plugins64" > 61csound5
	else
		echo "OPCODEDIR=/usr/$(get_libdir)/csound/plugins" > 61csound5
	fi
	echo "CSSTRNGS=/usr/share/locale" >> 61csound5
	doenvd 61csound5

	dodoc AUTHORS ChangeLog
	newdoc Loadable_Opcodes.txt Loadable_Opcodes
	newdoc readme-csound5.txt README.Csound5
	newdoc readme-csound5-complete.txt README.Csound5-VST
	if use doc; then
		dohtml -r "${WORKDIR}"/html/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PR}
		doins -r examples
	fi
}
