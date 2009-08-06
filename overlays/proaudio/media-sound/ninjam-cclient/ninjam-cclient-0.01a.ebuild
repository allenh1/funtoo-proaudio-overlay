# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

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

src_compile() {
	epatch ${FILESDIR}/add-jack-with-fixes.patch
	emake || die "make failed"
}

src_install() {
	dobin cninjam
}
