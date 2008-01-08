# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic multilib

MY_P="${PN}_src-v${PV}"

DESCRIPTION="JACK host for native linux VST, DSSI and LADSPA plugins with
sequencer capabilities"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=4"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="vst ladspa dssi"

RDEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
			virtual/x11 )
		media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
		vst? ( media-libs/vst-sdk )
		ladspa? ( media-libs/ladspa-sdk )
        dssi? ( media-libs/dssi )"

# uh, is there any better way to say following:
if use amd64 && use vst; then
	DEPEND="${DEPEND}
		app-emulation/emul-linux-x86-xlibs"
fi

S="${WORKDIR}/${PN}-v${PV}"

pkg_setup() {
	# at least one of those must be selected
	if ! use dssi; then
		if ! use ladspa; then
			if ! use vst; then
				echo
				eerror "Uhm, you disabled Support for all plugin systems!"
				eerror "This would make Jost quite useless."
				eerror "Please enable at least one of them!"
				echo
				die "No useflags enabled"
			fi
		fi
	fi

	# XCB issues
	if built_with_use x11-libs/libX11 xcb; then
		if has_version "<x11-libs/libxcb-1.1"; then
			eerror "You have libX11 compiled with xcb support, and you are"
			eerror "using libxcb older than version 1.1. Jost will not work."
			eerror "Please update your libxcb first"
			die
		fi
	fi
}

src_unpack() {
	unpack ${A}

	# patch use flags
	cd ${S}/plugins/Jost/src
	use vst || \
		sed -i -e "s:#define JOST_USE_VST://#define JOST_USE_VST:" \
		Config.h || die "bad sed"

	use ladspa || \
		sed -i -e "s:#define JOST_USE_LADSPA://#define JOST_USE_LADSPA:" \
		Config.h || die "bad sed"

	use dssi || \
		sed -i -e "s:#define JOST_USE_DSSI://#define JOST_USE_DSSI:" \
		Config.h || die "bad sed"

	# If USE="vst" is requested, we build 32bit on amd64
	# otherwhise you won't be able to load VSTs
	if use amd64 && use vst; then
			sed -i \
			-e 's:/usr/lib/:/usr/lib32/:' \
			-e 's:/usr/X11R6/lib/:/usr/X11R6/lib32/:' \
			"../build/linux/jost.make"
	fi

	# tmp fix, lash isn't needed
	sed -i -e 's:-llash ::' "../build/linux/jost.make"
}

src_compile() {
	# fails with --as-needed
	filter-ldflags --as-needed -Wl,--as-needed

	# If USE="vst" is requested, we build 32bit on amd64
	# otherwhise you won't be able to load VSTs
	if use amd64 && use vst; then
		multilib_toolchain_setup x86
		einfo "VST support requested. JOST will be built as 32bit binary"
	fi

	# build modified juce
	cd ${S}/juce/build/linux
	emake CONFIG=Release || die "building JUCE failed"

	# build jost
	cd ${S}/plugins/Jost/build/linux
	emake CONFIG=Release || die "building JOST failed"
}

src_install() {
	exeinto /usr/bin
	doexe bin/jost
	dodoc readme.txt
	doicon "${FILESDIR}/jost.png"
	make_desktop_entry "${PN}" "Jost" "${PN}" "AudioVideo;Audio;"
}

pkg_postinst() {
	elog "For some sample native linux VST's emerge some of"
	elog "media-plugins/vst_plugins-*"
	elog ""
	elog "You can also drag&drop LADSPA, DSSI and VST plugins from your plugin"
	elog "folders."

	if use amd64 && use vst; then
		echo
		elog "You have enabled the vst useflag on amd64. JOST has been"
		elog "built as 32bit binary, so you are able to load VSTs."
		elog "In conecquence, you will not be able to connect JOST to a"
		elog "64bit jackd instance! You can either emerge emul-linux-x86-jackd,"
		elog "install JOST in a 32bit chroot, or disable VST support for JOST."
	fi
	
	if built_with_use x11-libs/libX11 xcb; then
		ewarn "You have compiled libX11 with xcb enabled."
		ewarn "Make sure you use libxcb-1.1 or higher, and do"
		echo
		ewarn "export LIBXCB_ALLOW_SLOPPY_LOCK=1"
		echo
		ewarn "Otherwhise Jost will freeze after startup!"
	fi
}
