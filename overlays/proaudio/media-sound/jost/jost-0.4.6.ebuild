# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic multilib

MY_P="${PN}_src-v${PV}"

DESCRIPTION="JACK host for native linux VST, DSSI and LADSPA plugins with
sequencer capabilities"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=4"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
EAPI="1"
KEYWORDS="~x86 ~amd64"
IUSE="+vst ladspa dssi"

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

	if use amd64; then
		sed -i -e "s:#define JOST_USE_JACKBRIDGE         0:#define	JOST_USE_JACKBRIDGE         1:" \
		Config.h || die "bad sed"
	fi

	# fix VST header path
	sed -i -e 's:source/common:vst:g' "${S}/wrapper/formats/VST/juce_VstWrapper.cpp" || die

	# HACK!
	cd "${S}"
	use amd64 && epatch "${FILESDIR}/${P}-jostbridge-m64.patch"
}

src_compile() {
	# test.. we compile Release32, but with a 32bit toolchain, and compile
	# jackbridge with -m64, let's see
	use amd64 && multilib_toolchain_setup x86

	# fails with --as-needed
	filter-ldflags --as-needed -Wl,--as-needed

	# append -fPIC
	append-flags -fPIC -DPIC
	append-ldflags -fPIC -DPIC

	cd "${S}"/shared
	# non-standard configure
	./configure || die
	# jost and libs are compiled 32bit on amd64
	if use amd64; then
		./compile_libs Release32 || die
		./compile_jost Release32 || die
	else
		./compile_libs Release || die
		./compile_jost Release || die
	fi
}

src_install() {
	dobin bin/jost
	use amd64 && dobin bin/jostbridge
	dodoc readme.txt changelog.txt
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
		elog "You have to start jostbridge prior to jost!"
		echo
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
