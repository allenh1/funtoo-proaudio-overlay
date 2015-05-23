# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

IUSE=""
DESCRIPTION="An lv2 vocoder plugin"
HOMEPAGE="http://gna.org/projects/lv2vocoder"
SRC_URI="http://download.gna.org/lv2vocoder/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
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
	dodir /usr/$(get_libdir)/lv2
	LV2_PATH="${D}/usr/$(get_libdir)/lv2" make DESTDIR="${D}" install || die "Install failed"
	dodoc NEWS AUTHORS README ChangeLog
}
