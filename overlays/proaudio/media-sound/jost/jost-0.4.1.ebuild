# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

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

S="${WORKDIR}/${PN}-v${PV}"

pkg_setup() {
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
}
	
src_compile() {
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
	dodoc plugins/Jost/readme.txt
	doicon "${FILESDIR}/jost.png"
	make_desktop_entry "${PN}" "Jost" "${PN}" "AudioVideo;Audio;"
}

pkg_postinst() {
	elog "For some sample native linux VST's emerge some of"
	elog "media-plugins/vst_plugins-*"
	elog ""
	elog "You can also drag&drop LADSPA, DSSI and VST plugins from your plugin"
	elog "folders."
}
