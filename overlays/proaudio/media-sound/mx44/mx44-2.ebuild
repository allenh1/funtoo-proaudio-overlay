# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator
RESTRICT="mirror"
MY_PN="${PN/m/M}"
MY_P="${MY_PN}.$(replace_version_separator "0" "-")"

DESCRIPTION="Mx44 is a polyphonic midi realtime software synthesizer"
HOMEPAGE="http://web.comhem.se/luna/"
SRC_URI="http://web.comhem.se/luna/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DOCS=( "${WORKDIR}/${MY_P}/README" )

IUSE=""
DEPEND="media-sound/jack-audio-connection-kit
		>=x11-libs/gtk+-2.0
		media-libs/alsa-lib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	echo 'FLAGS += $(CFLAGS)' >> Makefile
}
