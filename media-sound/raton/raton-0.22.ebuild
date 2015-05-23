# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils

IUSE=""
RESTRICT="mirror"

DESCRIPTION="Mouse driven MIDI controller."
HOMEPAGE="http://home.earthlink.net/~gmoonlit/raton/raton.html"
MY_P="${P/-/_v}"
SRC_URI="http://home.earthlink.net/~gmoonlit/raton/data/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=media-libs/alsa-lib-0.9
	>=x11-libs/gtk+-2.4"

AUTOTOOLS_AUTORECONF="1"

PATCHES=(
	"${FILESDIR}/${P}-libm.patch"
	"${FILESDIR}/${P}-include-math.patch"
	"${FILESDIR}/${P}-arguments.patch"
)

src_install() {
	autotools-utils_src_install
	make_desktop_entry "${PN}" "${PN} mouse to MIDI" "${PN}" "AudioVideo;Audio;Midi"
}
