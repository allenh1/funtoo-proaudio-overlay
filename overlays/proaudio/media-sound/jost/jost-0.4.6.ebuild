# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic multilib

MY_P="${PN}_src-v${PV}"

DESCRIPTION="JACK host for native linux VST, DSSI and LADSPA plugins with
sequencer capabilities"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=4"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+vst ladspa dssi"

RDEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
			virtual/x11 )
		media-sound/jack-audio-connection-kit
		vst? ( media-libs/vst-sdk )
		ladspa? ( media-libs/ladspa-sdk )
		dssi? ( media-libs/dssi )"
DEPEND="${RDEPEND}"

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
}

src_prepare() {
	# patch use flags
	cd "${S}/plugins/Jost/src"
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

src_configure() {
	cd "${S}/shared"
	# test.. we compile Release32, but with a 32bit toolchain, and compile
	# jackbridge with -m64, let's see
	use amd64 && multilib_toolchain_setup x86

	# fails with --as-needed
	filter-ldflags --as-needed -Wl,--as-needed

	# append -fPIC
	append-flags -fPIC -DPIC
	append-ldflags -fPIC -DPIC

	# non-standard configure
	./configure || die
}

src_compile() {
	cd "${S}/shared"
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
	doicon "${FILESDIR}/jost.xpm"
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
}
