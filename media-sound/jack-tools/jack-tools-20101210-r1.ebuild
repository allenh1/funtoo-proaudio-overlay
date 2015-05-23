# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A collection of audio tools for jack"
HOMEPAGE="http://rd.slavepianos.org/?t=rju"
SRC_URI="mirror://ubuntu/pool/universe/j/${PN}/${PN}_${PV}.orig.tar.gz
mirror://ubuntu/pool/universe/j/${PN}/${PN}_${PV}-2.debian.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc"

RDEPEND="media-libs/libsndfile
	>=media-sound/jack-audio-connection-kit-0.109.2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	doc? ( app-text/asciidoc )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}.orig
RESTRICT="mirror"

DOCS=(README)

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}"/debian/patches \
		epatch $(< "${WORKDIR}"/debian/patches/series)

	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install

	dodoc *.text

	if use doc; then
		local x=
		for x in *.text; do
			asciidoc "${x}"
		done

		dohtml *.html
	fi
}
