# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN/-/_}_${PV}"

DESCRIPTION="NINJAM is a program to allow people to make real music together via
the Internet"
HOMEPAGE="http://www.ninjam.com"
SRC_URI="http://www.ninjam.com/downloads/src/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
S="${WORKDIR}/${MY_P}/ninjam/server"

DEPEND="virtual/libc"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin ninjamsrv
}

