# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

DESCRIPTION="A basic console based DPM (Digital Peak Meter) for JACK"
HOMEPAGE="http://www.aelius.com/njh/jackmeter"
SRC_URI="http://www.aelius.com/njh/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(AUTHORS README TODO)
