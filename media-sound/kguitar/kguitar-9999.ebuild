# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils eutils kde4-base subversion

DESCRIPTION="An efficient and easy-to-use environment for a guitarist."
HOMEPAGE="http://kguitar.sourceforge.net/"
#SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"
ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}/branches/kde4/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/tse3"
DEPEND="${RDEPEND}"
S=${WORKDIR}/kde4

src_configure() {
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
