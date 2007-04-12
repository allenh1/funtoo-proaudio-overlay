# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}_src-v${PV}"

DESCRIPTION="host for native linux vst plugins"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=4"
SRC_URI="http://www.anticore.org/jucetice/wp-content/uploads/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
			virtual/x11 )
		media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
		media-libs/vst-sdk"

S="${WORKDIR}/${PN}"

src_compile() {
	# build modified juce
	cd juce/build/linux
	emake CONFIG=Release || die "building JUCE failed"

	# build jost
	cd ../../../plugins/Jost/build/linux
	emake CONFIG=Release || die "building JOST failed"
}

src_install() {
	exeinto /usr/bin
	doexe plugins/Jost/build/linux/jost
	dodoc plugins/Jost/readme.txt
}

pkg_postinst() {
	elog "For some sample native linux VST's emerge some of"
	elog "media-plugins/vst_plugins-*"
	elog "Then start JOST with:"
	elog "jost /usr/lib/vst/<name>.so"
}
