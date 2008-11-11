# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion

RESTRICT="nomirror"
IUSE="debug"
DESCRIPTION="An STL-style C++ wrapper for the Redland RDF Toolkit (librdf)"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
DEPEND=">=dev-util/pkgconfig-0.9.0
	dev-libs/redland
	dev-libs/boost
	>=dev-cpp/glibmm-2.4"

src_compile() {
	cd ${S}/${PN}
	
	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"
	
	./waf configure ${myconf} || die
	
	./waf build ${MAKEOPTS} || die
}

src_install() {
	cd ${S}/${PN}
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README
}
