# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""
DESCRIPTION="An lv2 vocoder plugin"
HOMEPAGE="https://gna.org/projects/lv2vocoder"
SRC_URI="http://download.gna.org/lv2vocoder/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=""
src_unpack() {
	unpack ${A}|| die "Unpacking failed"
}

src_compile() {
#	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	dodir /usr/lib/lv2
	LV2_PATH="${D}/usr/lib/lv2" make DESTDIR="${D}" install || die "Install failed"
	dodoc NEWS AUTHORS README ChangeLog
}
