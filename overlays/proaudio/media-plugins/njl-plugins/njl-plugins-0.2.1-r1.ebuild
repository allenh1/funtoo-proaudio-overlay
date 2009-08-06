# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
IUSE=""
DESCRIPTION="NJL LADSPA audio plugins/effects"
HOMEPAGE="http://devel.tlrmx.org/audio"
SRC_URI="http://devel.tlrmx.org/audio/source/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"

S="${WORKDIR}/${PN}"

src_install() {
	dodoc PLUGINS README
	insinto /usr/lib/ladspa
	insopts -m0755
	doins eir_1923.so noise_1921.so noise_1922.so risset_1924.so
}
