# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
DESCRIPTION="Ulis LV2 Inserts. A series of LV2 plugins. There is already a AND
NAND OR NOR XOR XNOR NOT and SR, JK, D, T FlipFlops and Latches"
HOMEPAGE="http://sourceforge.net/projects/uli-plugins/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=dev-util/lv2-c++-tools-1.0.2"

src_compile() {
	./waf configure --prefix=/usr || die "failed to configure"
	./waf build || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
}
