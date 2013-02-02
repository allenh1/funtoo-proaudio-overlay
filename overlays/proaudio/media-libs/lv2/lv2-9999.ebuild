# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit subversion waf-utils python-single-r1

RESTRICT="mirror"
DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
SRC_URI=""
ESVN_REPO_URI="http://lv2plug.in/repo/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc debug plugins"

RDEPEND="!<media-libs/slv2-0.4.2"
DEPEND="${RDEPEND}
doc? (	app-doc/doxygen
		app-text/asciidoc
		dev-python/rdflib )"

DOCS=( README )

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	local mywafconfargs=""
	use debug && mywafconfargs+="--debug "
	use doc && mywafconfargs+="--docs "
	use plugins || mywafconfargs+="--no-plugins"

	waf-utils_src_configure ${mywafconfargs}
}
