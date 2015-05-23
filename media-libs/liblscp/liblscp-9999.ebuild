# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
AUTOTOOLS_AUTORECONF=1
inherit subversion autotools-utils

DESCRIPTION="a C++ library for the Linux Sampler control protocol."
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/liblscp/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

src_install() {
	use doc && HTML_DOCS=("${BUILD_DIR}"/doc/html/)
	autotools-utils_src_install
}
