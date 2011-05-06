# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

MY_PN=${PN/-/.}

DESCRIPTION="A port of Paul Kellett's MDA VST plugins to LV2"
HOMEPAGE="http://drobilla.net/software/"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=">=media-libs/lv2core-4.0"
DEPEND="${RDEPEND}"

src_configure() {
	cd "plugins/${MY_PN}"
	waf-utils_src_configure
}

src_compile() {
	cd "plugins/${MY_PN}"
	waf-utils_src_compile
}

src_install() {
	cd "plugins/${MY_PN}"
	waf-utils_src_install
	dodoc README
}
