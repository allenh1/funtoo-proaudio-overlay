# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
MY_P="${P/amb/AMB}"
DESCRIPTION="AMB ladspa plugins package"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"

S="${WORKDIR}/${MY_P}"
src_install() {
	dodoc AUTHORS README
	insinto /usr/lib/ladspa
	insopts -m0755
	doins *.so
}
