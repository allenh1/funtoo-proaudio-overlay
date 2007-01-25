# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Aldrin is an open source modular sequencer/tracker, compatible to
Buzz"
HOMEPAGE="http://trac.zeitherrschaft.org/aldrin/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/wxpython
	dev-python/ctypes
	>=media-libs/libzzub-0.2"

DEPEND="${RDEPEND}
	dev-util/scons"

src_install() {
	scons PREFIX=/usr DESTDIR="${D}" install || die "install failed"
	dodoc CREDITS ChangeLog
}
