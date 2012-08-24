# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base

DESCRIPTION="Sound effect generator with SDL GUI"
HOMEPAGE="http://www.drpetter.se/project_sfxr.html"
SRC_URI="http://www.drpetter.se/files/${PN}-sdl-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[audio,video]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-sdl-${PV}

DOCS=(ChangeLog readme.txt)

PATCHES=("${FILESDIR}/${P}-Makefile.patch")

src_compile() {
	CXX="$(tc-getCXX)" base_src_compile
}
