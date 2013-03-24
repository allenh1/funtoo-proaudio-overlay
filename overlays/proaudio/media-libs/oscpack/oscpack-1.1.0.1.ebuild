# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils cmake-utils versionator
RESTRICT="mirror"

DESCRIPTION="Set of C++ classes for packing and unpacking OSC packets"
HOMEPAGE="http://www.rossbencina.com/code/${PN}"

MY_P="$(version_format_string '${PN}_$1_$2_$3_RC$4')"

SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

RDEPEND=""
DEPEND="app-arch/unzip
	${RDEPEND}"

CMAKE_IN_SOURCE_BUILD="1"

PATCHES=( "${FILESDIR}/${P}-shared.patch" )

DOCS=( CHANGES LICENSE README TODO )

src_install() {
	dolib "lib${PN}.so"
	insinto "/usr/include/${PN}/ip"
	doins ip/*.h
	insinto "/usr/include/${PN}/osc"
	doins osc/*.h
	base_src_install_doc
}
