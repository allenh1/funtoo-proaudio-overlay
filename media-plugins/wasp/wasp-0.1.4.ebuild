# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

RESTRICT="mirror"
IUSE="doc"
DESCRIPTION="Wave Sculpting LADSPA audio plugins/effects"
HOMEPAGE="http://linux01.gwdg.de/~nlissne/wasp/"
SRC_URI="http://linux01.gwdg.de/~nlissne/wasp/${P}.tar.bz2
	doc? ( http://linux01.gwdg.de/~nlissne/wasp/${PN}-docs-${PV}.tar.bz2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"

src_install() {
	dodoc  AUTHORS ChangeLog
	use doc && dohtml -r "${WORKDIR}/${PN}-docs-${PV}/"
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins  "${S}"/plugins/wasp-*.so
}
