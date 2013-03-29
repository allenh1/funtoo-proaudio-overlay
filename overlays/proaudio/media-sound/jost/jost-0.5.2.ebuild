# Copyright 1999-2013 Gentoo Foundation
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
IUSE="alsa +vst ladspa lash dssi opengl"

RDEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
			virtual/x11 )
	media-sound/jack-audio-connection-kit
	dssi? ( media-libs/dssi )
	lash? ( media-sound/lash )
	opengl? ( virtual/opengl )
	alsa? ( media-libs/alsa-lib )
	amd64? ( vst? ( app-emulation/emul-linux-x86-xlibs ) )"
DEPEND="${RDEPEND}
	vst? ( media-libs/vst-sdk )
	ladspa? ( media-libs/ladspa-sdk )
	dev-util/premake:3"

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
	# fix VST header path
	sed -i -e 's:source/common:vst:g' "${S}/wrapper/formats/VST/juce_VstWrapper.cpp" || die

	if use amd64; then
		sed -i -e "s:#define JOST_USE_JACKBRIDGE         0:#define		JOST_USE_JACKBRIDGE         1:" \
		"${S}/src/Config.h" || die "bad sed"
	fi
}

src_compile() {
	cd "${S}"/build/linux

	premake \
		--file premake.lua \
		--cc gcc --target gnu --os linux \
		`use_enable alsa` \
		`use_enable opengl` \
		`use_enable lash` \
		`use_enable vst` \
		`use_enable ladspa` \
		`use_enable dssi` \
		|| die "premake failed"

	local myconf="CONFIG=Release"

	# we compile Release32, but with a 32bit toolchain
	if use amd64 && use vst; then
		multilib_toolchain_setup x86
		myconf="CONFIG=Release32 JOST_USE_JACKBRIDGE=1"
	fi

	# fails with --as-needed
	filter-ldflags --as-needed -Wl,--as-needed

	# append -fPIC
	append-flags -fPIC -DPIC
	append-ldflags -fPIC -DPIC

	einfo "Running \"make ${myconf}\" ..."
	make ${myconf} || die
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
		elog "You have to start jostbridge prior to jost, or use ALSA output!"
		echo
	fi
}
