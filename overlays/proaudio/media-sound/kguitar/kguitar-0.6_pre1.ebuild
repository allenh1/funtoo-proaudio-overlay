# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils eutils kde4-base

DESCRIPTION="An efficient and easy-to-use environment for a guitarist."
HOMEPAGE="http://kguitar.sourceforge.net/"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tse3"

RDEPEND="media-libs/tse3"
DEPEND="${RDEPEND}"
S=${WORKDIR}/kde4

PATCHES=(
#	"${FILESDIR}"/${P}+gcc-4.3.patch
#	"${FILESDIR}"/kguitar-0.5-desktop-file.diff
	"${FILESDIR}"/${P}-gcc-songview.patch
	)

src_configure() {
#		$(cmake-utils_use_want alsa ALSA)
#		$(cmake-utils_use_want tse3 TSE3)"
	cmake-utils_src_configure

}
src_compile() {
	cmake-utils_src_compile
CMAKE_USE_DIR=${WORKDIR}/${P}_build
cd "${CMAKE_USE_DIR}"
	emake || die "emake failed"
}

src_install() {
	cmake-utils_src_install
}
