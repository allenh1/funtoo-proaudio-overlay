# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit multilib toolchain-funcs subversion

DESCRIPTION="LV2 is a simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
ESVN_REPO_URI="http://lv2plug.in/repo/trunk"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="!<media-libs/slv2-0.4.2"

S="${WORKDIR}"

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	./waf configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) || die
}

src_compile() {
	./waf || die
}

src_install() {
	./waf install --destdir="${D}" || die
	dodoc README
	docinto core.lv2
	dodoc core.lv2/{ChangeLog,README}
}

pkg_postinst() {
	# required to create the structure of symlinks to the lv2 extension headers
	lv2config || die
}
