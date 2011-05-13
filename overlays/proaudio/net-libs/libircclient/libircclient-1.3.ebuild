# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A library implementing the client-server IRC protocol"
HOMEPAGE="http://libircclient.sourceforge.net/";
SRC_URI="mirror://sourceforge/libircclient/${PV}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

src_install () {
	dolib.a src/libircclient.a
	dodir /usr/include/libircclient
	insinto /usr/include/libircclient
	doins include/libirc{client,_errors,_events,_options,_rfcnumeric}.h
	doman doc/man/man3/*.3
	dodoc README THANKS Changelog doc/rfc1459.txt
	if use doc; then
		dohtml doc/html/* || die "Installing the docs failed!"
	fi
}
