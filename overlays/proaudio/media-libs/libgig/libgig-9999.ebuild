# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
AUTOTOOLS_AUTORECONF=1
inherit subversion autotools-utils

DESCRIPTION="a C++ library for loading Gigasampler files and DLS (Downloadable Sounds) Level 1/2 files."
HOMEPAGE="http://www.linuxsampler.org/libgig/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/libgig/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

src_compile() {
	autotools-utils_src_compile -j1
	use doc && autotools-utils_src_compile -j1 docs
}

src_install() {
	use doc && HTML_DOCS=("${BUILD_DIR}"/doc/html/)
	autotools-utils_src_install
}
