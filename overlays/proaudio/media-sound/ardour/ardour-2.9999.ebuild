# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils fetch-tools scons-ccache subversion vst

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/2.0-ongoing"
ESVN_RESTRICT="export"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls debug sse altivec vst sys-libs"

RDEPEND=">=media-libs/liblrdf-0.4.0
	>=media-libs/aubio-0.3.2
	>=media-libs/raptor-1.2.0
	>=media-libs/libart_lgpl-2.3.16
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsamplerate-0.0.14
	media-libs/liblo
	>=dev-libs/libxml2-2.5.7
	dev-libs/libxslt
	>=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.6
	>=media-sound/jack-audio-connection-kit-0.100.0
	>=gnome-base/libgnomecanvas-2.0
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*
	sys-libs? ( >=dev-libs/libsigc++-2.0
		>=dev-cpp/glibmm-2.4
		>=dev-cpp/cairomm-1.0
		>=dev-cpp/gtkmm-2.8
		>=dev-libs/atk-1.6
		>=x11-libs/pango-1.4
		>=dev-cpp/libgnomecanvasmm-2.12.0
		>=media-libs/libsndfile-1.0.16
		>=media-libs/libsoundtouch-1.0 )"
		# currently internal rubberband is used
		# that needs fftw3 and vamp-sdk, but it rocks, so enable by default
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	sys-devel/bison
	sys-devel/autoconf
	sys-devel/automake
	>=dev-util/pkgconfig-0.8.0
	>=dev-util/scons-0.96.1
	nls? ( >=sys-devel/gettext-0.12.1 )"

S="${WORKDIR}/ardour2"

pkg_setup(){
	einfo "this ebuild fetches from the svn maintaince"
	einfo "ardour-2.0.XXX branch"
	# issue with ACLOCAL_FLAGS if set to a wrong value
	if use sys-libs;then
		ewarn "You are trying to use the system libraries"
		ewarn "instead the ones provided by ardour"
		ewarn "No upstream support for doing so. Use at your own risk!!!"
		ewarn "To use the ardour provided libs remerge with:"
		ewarn "USE=\"-sys-libs\" emerge =${P}"

		epause 3s
	fi

	if use amd64 && use vst; then
		eerror "${P} currently does not compile with VST support on amd64!"
		eerror "Please unset VST useflag."
		die
	fi
}

src_unpack(){
	# abort if user answers no to distribution of vst enabled binaries
	if use vst; then 
		agree_vst || die "you can not distribute ardour with vst support"
	fi
	subversion_src_unpack
	subversion_wc_info
	einfo "Copying working copy to source dir:"
	mkdir -p "${S}"
	cp -R "${ESVN_WC_PATH}"/* "${S}"
	cp -R "${ESVN_WC_PATH}"/.* "${S}"
	cd ${S}

	# hack to use the sys-lib for sndlib also
	use sys-libs && epatch "${FILESDIR}/ardour-2.0.3-sndfile-external.patch"

	add_ccache_to_scons

	ardour_vst_prepare
}

src_compile() {
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	local myconf=""
	(use sse || use altivec) && myconf="FPU_OPTIMIZATION=1"
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?"
	! use vst; myconf="${myconf} VST=$?"
	! use sys-libs; myconf="${myconf} SYSLIBS=$?"
	! use sse; myconf="${myconf} USE_SSE_EVERYWHERE=$? BUILD_SSE_OPTIMIZATIONS=$?"
	# static settings
	myconf="${myconf} PREFIX=/usr KSI=0" # NLS=0"
	einfo "${myconf}"

	cd ${S}
	escons ${myconf}	${MAKEOPTS} || die "compilation failed"
}

src_install() {
	escons DESTDIR="${D}" install || die "make install failed"
	if use vst;then
		mv "${D}"/usr/bin/ardourvst "${D}"/usr/bin/ardour2
	fi

	dodoc  DOCUMENTATION/*

	doicon "${S}/icons/icon/ardour_icon_mac.png"
	make_desktop_entry ardour Ardour ardour_icon_mac.png "AudioVideo;Audio"
}
