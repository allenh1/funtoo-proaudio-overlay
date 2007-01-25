# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
DESCRIPTION="NJL LADSPA audio plugins/effects"
HOMEPAGE="http://devel.tlrmx.org/audio"
SRC_URI="http://devel.tlrmx.org/audio/source/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="media-libs/ladspa-sdk"

S="${WORKDIR}/${PN}"

src_install() {
	dodoc COPYING PLUGINS README
	insinto /usr/lib/ladspa
	insopts -m0755
	doins *.so
}
