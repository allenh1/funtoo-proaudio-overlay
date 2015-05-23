# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_{6,7} )
AUTOTOOLS_AUTORECONF=true
AT_M4DIR="m4"
inherit subversion autotools-utils python-r1

DESCRIPTION="python binding for phat"
HOMEPAGE="http://phat.berlios.de/"
ESVN_REPO_URI="svn://svn.berlios.de/phat/trunk/pyphat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=media-libs/phat-0.4
	>=dev-python/pygtk-2.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_prepare() {
	autotools-utils_src_prepare
	python_copy_sources
}

src_configure() {
	pyphat_configure() {
		run_in_build_dir autotools-utils_src_configure
	}
	python_foreach_impl pyphat_configure
}

src_compile() {
	pyphat_compile() {
		run_in_build_dir autotools-utils_src_compile
	}
	python_foreach_impl pyphat_compile
}

src_install() {
	pyphat_install() {
		run_in_build_dir autotools-utils_src_install
		python_optimize "${ED}"/$(python_get_sitedir)
	}
	python_foreach_impl pyphat_install
}
