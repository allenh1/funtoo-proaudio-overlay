# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A collection of presets for Jamin made by Gilberto Andre Borges"
HOMEPAGE="http://musix.codigolivre.org.br/"
SRC_URI="ftp://codigolivre.org.br/pub/linaudiobr/jaminpresets/jaminpresetsGilbertoABOrges-${PV}_all.tar.gz/jaminpresets${PV}_all.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="media-sound/jamin"
S="${WORKDIR}/${MY_PN}"

src_install() {
	insinto /usr/share/jamin/presets
	cd "${S}/usr/share/jamin/presets"
	dodoc 1_SOBREPRESETS
	rm 1_SOBREPRESETS
	doins *
}
