# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic

DESCRIPTION="Tool for storing/restoring JACK and/or ALSA connections to/from cml files."
HOMEPAGE="http://sourceforge.net/projects/aj-snapshot/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-libs/mini-xml
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit"
RDEPEND="$DEPEND"

pkg_setup() {
	append-ldflags $(no-as-needed)
}
