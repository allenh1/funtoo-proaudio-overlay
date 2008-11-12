# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion

DESCRIPTION="LV2 is a simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="!<media-libs/slv2-0.4.2"

src_compile() {
	cd ${PN}

	# fix .pc/header install...
	sed -i -e 's:bundle_only != False:bundle_only != True:' wscript || die

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die "configure failed"
	./waf build ${MAKEOPTS} || die "waf failed"
}

src_install() {
	cd ${PN}
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS README
}
