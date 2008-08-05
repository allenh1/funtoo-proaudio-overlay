# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit exteutils toolchain-funcs flag-o-matic scons-ccache vst versionator patcher

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="http://ardour.org/files/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="altivec debug nls sse +sys-libs vst lv2 freesound custom-cflags"

RDEPEND="media-libs/liblo
	>=media-libs/liblrdf-0.4.0
	>=media-libs/raptor-1.4.2
	>=media-sound/jack-audio-connection-kit-0.109.2
	>=dev-libs/glib-2.10.3
	>=x11-libs/gtk+-2.8.8
	media-libs/flac
	>=media-libs/alsa-lib-1.0.14a-r1
	>=media-libs/libsamplerate-0.1.1-r1
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	gnome-base/libgnomecanvas
	dev-libs/libusb
	=sci-libs/fftw-3*
	sys-libs? ( >=dev-libs/libsigc++-2.0
		>=dev-cpp/cairomm-1.0
		>=dev-cpp/gtkmm-2.10
		>=dev-cpp/glibmm-2.4
		>=dev-libs/atk-1.6
		>=x11-libs/pango-1.4
		>=dev-cpp/libgnomecanvasmm-2.12.0
		>=media-libs/libsndfile-1.0.16
		>=media-libs/libsoundtouch-1.0 )
	freesound? ( net-misc/curl )
	lv2? ( >=media-libs/slv2-0.6.0 )"

DEPEND="${RDEPEND}
	sys-devel/libtool
	dev-libs/boost
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use amd64 && use vst; then
		eerror "${P} currently does not compile with VST support on amd64!"
		eerror "Please unset VST useflag."
		die
	fi

	if use sys-libs;then
		ewarn "You are trying to use the system libraries"
		ewarn "instead the ones provided by ardour"
		ewarn "No upstream support for doing so. Use at your own risk!!!"
		ewarn "To use the ardour provided libs remerge with:"
		ewarn "USE=\"-sys-libs\" emerge =${P}"

		if ! built_with_use dev-cpp/gtkmm accessibility; then
			eerror "dev-cpp/gtkmm needs to be built with use accessibility"
			eerror "in order to build ${PN}"
			die "gtkmm was not built with use accessibility"
		fi
		epause 3s
	fi
}

ardour_use_enable() {
	use ${2} && echo "${1}=1" || echo "${1}=0"
}

src_unpack() {
	# abort if user answers no to distribution of vst enabled binaries
	if use vst;	then
		agree_vst || die "you can not distribute ardour with vst support"
	fi

	unpack ${A}
	cd "${S}"

	# SYSLIBS also use external sndfile
	use sys-libs && epatch "${FILESDIR}/${PN}-2.0.3-sndfile-external.patch"
	# optional custom cflags
	use custom-cflags && epatch "${FILESDIR}/${PN}-2.4-cflags.patch"
	# find libsoundtouch
	esed_check -i -e 's@\(libraries.*\)libSoundTouch@\1 soundtouch-1.0@g' SConstruct 

	# set up VST stuff
	ardour_vst_prepare
}

src_compile() {
	# Required for scons to "see" intermediate install location
	mkdir -p "${D}"

	#local FPU_OPTIMIZATION="$((use altivec || use sse) && echo 1 || echo 0)"
	cd "${S}"

	tc-export CC CXX
	add_ccache_to_scons

	# Avoid compiling x86 asm when building on amd64 without using sse
	# bug #186798
	# NOTE: this doesn't work
	#use amd64 && append-flags "-DUSE_X86_64_ASM"

	# touching FPU_OPTIMIZATION only if sse altivec is enabled, otherwhise
	# don't even specify it

	local myconf=""
	(use sse || use altivec) && myconf="FPU_OPTIMIZATION=1"

	scons \
		$(ardour_use_enable DEBUG debug) \
		$(ardour_use_enable NLS nls) \
		$(ardour_use_enable VST vst) \
		$(ardour_use_enable SYSLIBS sys-libs) \
		$(ardour_use_enable LV2 lv2) \
		$(ardour_use_enable FREESOUND freesound) \
		DESTDIR="${D}" \
		CFLAGS="${CFLAGS}" \
		PREFIX=/usr \
		${myconf} \
		|| die "scons make failed"
}

src_install() {
	scons install || die "make install failed"

	dodoc DOCUMENTATION/*

	doicon "${S}/icons/icon/ardour_icon_mac.png"
	make_desktop_entry ardour Ardour ardour_icon_mac.png "AudioVideo;Audio"

	if use vst; then
		mv "${D}"/usr/bin/ardourvst "${D}"/usr/bin/ardour2
	fi
}

pkg_postinst() {
	ewarn "---------------- WARNING -------------------"
	ewarn ""
	ewarn "Do not use Ardour 2.0 to open the only copy of sessions created with Ardour 0.99."
	ewarn "Ardour 2.0 saves the session file in a new format that Ardour 0.99 will"
	ewarn "not understand."
	ewarn ""
	ewarn "MAKE BACKUPS OF THE SESSION FILES."
	ewarn ""
	ewarn "The simplest way to address this is to make a copy of the session file itself"
	ewarn "(e.g mysession/mysession.ardour) and make that file unreadable using chmod(1)."
	ewarn ""
	ewarn "---------------- WARNING -------------------"
	ewarn ""
	ewarn "If you use KDE 3.5, be sure to uncheck 'Apply colors to non-KDE applications' in"
	ewarn "the colors configuration module if you want to be able to actually see various"
	ewarn "texts in Ardour 2."
}
