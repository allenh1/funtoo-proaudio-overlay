# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils

MY_P=hid-${PV}

DESCRIPTION="The hid external for pure data."
HOMEPAGE="http://at.or.at/hans/pd/hid.html"
SRC_URI="http://at.or.at/hans/pd/${MY_P}.tar.bz2"

LICENSE="|| ( BSD as-is )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug examples"

S="${WORKDIR}/${MY_P}"

RDEPEND="media-sound/pd"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-Makefile.patch"
	use debug && epatch "${FILESDIR}/${P}-debug.patch"
}

src_compile() {
	make clean
	make OUR_CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	insinto "/usr/lib/pd/doc/5.reference"
	doins doc/*-help.pd
	
	insinto "/usr/lib/pd/extra/hid"
	fperms 0755 *.pd_linux
	doins	*.pd *.pd_linux

	dodoc README TODO
	
	if use examples ; then
		insinto "/usr/share/doc/${P}/examples"
		doins *pd examples/*pd
	fi
}
