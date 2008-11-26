# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils multilib

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

DESCRIPTION="Collection of lv2 plugins for modular synthesizers."
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug"

DEPEND=">=media-libs/lv2core-2.0"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	
	local myconf="--prefix=/usr"
	use debug && myconf="${myconf} --debug"
	./waf configure ${myconf} || die
	./waf build || die
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	./waf install --destdir="${D}" || die
	dodoc NEWS AUTHORS README ChangeLog
}
