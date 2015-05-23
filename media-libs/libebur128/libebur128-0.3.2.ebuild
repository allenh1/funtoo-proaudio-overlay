# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=0

inherit eutils cmake-utils

MY_PV="${PV}-Source"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Tools for implementing the EBU R128 loudness standard."
HOMEPAGE="http://www-public.tu-bs.de:8080/~y0035293/libebur128.html"
SRC_URI="http://www-public.tu-bs.de:8080/~y0035293/${MY_P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND="
	media-libs/libsndfile
	media-libs/taglib
	media-sound/musepack-tools
	media-sound/mpg123
	virtual/ffmpeg
	"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cd ${CMAKE_BUILD_DIR}
	dobin r128-*
}
