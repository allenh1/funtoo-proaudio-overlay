# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="threads(+),xml(+)"
inherit git-r3 multilib python-single-r1 waf-utils

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
EGIT_REPO_URI="http://lv2plug.in/git/lv2.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc debug plugins"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		app-text/asciidoc
	)"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	local mywafconfargs=(
		--lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2
		--copy-headers
		$(usex debug --debug "")
		$(usex doc --docs "")
		$(usex plugins "" --no-plugins)
	)

	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
