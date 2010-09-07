# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
CMAKE_IN_SOURCE_BUILD="1"

inherit eutils qt4-r2 subversion cmake-utils

ESVN_REPO_URI="svn://svn.berlios.de/canorus/trunk"
ESVN_PROJECT="canorus"

DESCRIPTION="a free extensible music score editor"
HOMEPAGE="http://canorus.berlios.de"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="ruby"

RDEPEND=">=dev-lang/python-2.5
	sys-libs/zlib
	media-libs/alsa-lib
	>=x11-libs/qt-svg-4.4:4
	>=x11-libs/qt-core-4.4:4
	ruby? ( dev-lang/ruby )"
	#>=x11-libs/qt-assistant-4.4:4

DEPEND="${REDEND}
	dev-lang/swig"

pkg_setup() {
	ewarn "if this ebuild fails have a look at"
	ewarn "http://bugs.gentoo.org/show_bug.cgi?id=157501"
	ewarn "hav no time to fix the ebuild"

	mycmakeargs+=" -DCANORUS_INSTALL_LIB_DIR=$(get_libdir) \
		-DNO_RUBY=$( use ruby && echo false || echo true ) \
		-DNO_PYTHON=false"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-MAKE_DIRECTORY.patch"
}

src_unpack() {
	subversion_src_unpack
}
