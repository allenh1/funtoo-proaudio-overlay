# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_P="cclient_src_v${PV}"

DESCRIPTION="NINJAM is a program to allow people to make real music together via
the Internet"
HOMEPAGE="http://www.ninjam.com/"
SRC_URI="http://www.ninjam.com/downloads/src/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S="${WORKDIR}"

DEPEND=">=media-sound/jack-audio-connection-kit-0.100
		sys-libs/ncurses
		media-libs/libogg
		media-libs/libvorbis"
RDEPEND="${DEPEND}"

src_compile() {
	epatch "${FILESDIR}/${P}-add-jack-with-fixes.patch"
	epatch "${FILESDIR}/${P}-Makefile.patch"

	cd ninjam/cursesclient || die "cd ninjam/cursesclient failed"

	tc-export CC CXX
	OPTFLAGS="${CXXFLAGS}" emake || die "make failed"
}

src_install() {
	cd ninjam/cursesclient || die "cd ninjam/cursesclient failed"
	dobin cninjam || die
}
