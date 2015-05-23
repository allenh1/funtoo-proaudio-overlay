# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils

RESTRICT="mirror"

DESCRIPTION="a pattern-based MIDI sequencer."
HOMEPAGE="http://${PN}.nongnu.org"

SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="debug"

RDEPEND=">=dev-cpp/libglademm-2.4.1
	>=dev-cpp/libxmlpp-2.6.1
	media-sound/jack-audio-connection-kit
	virtual/liblash"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=( $(use_enable debug) )
	autotools-utils_src_configure
}
