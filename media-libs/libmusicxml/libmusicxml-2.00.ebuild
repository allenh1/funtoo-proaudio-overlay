# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils eutils

DESCRIPTION="C++ support for the MusicXML support"
HOMEPAGE="http://libmusicxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-util/scons"

S="${WORKDIR}/${P}-src/cmake"

src_configure() {
	cmake-utils_src_configure

}
src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
