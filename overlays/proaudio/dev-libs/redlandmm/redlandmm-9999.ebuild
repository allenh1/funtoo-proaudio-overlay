# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

RESTRICT="nomirror"
IUSE="debug"
DESCRIPTION="An STL-style C++ wrapper for the Redland RDF Toolkit (librdf)"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
DEPEND=">=dev-util/pkgconfig-0.9.0
	dev-libs/redland
	dev-libs/boost
	>=dev-cpp/glibmm-2.4"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	cd "${S}/${PN}" || die "source for ${PN} not found"
	NOCONFIGURE=1 ./autogen.sh
	econf $(use_enable debug) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README
} 
