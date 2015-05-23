# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit multilib toolchain-funcs

DESCRIPTION="Ulis LV2 Insert series plugins. AND NAND OR NOR XOR XNOR NOT and SR, JK, D, T FlipFlops and Latches"
HOMEPAGE="http://sourceforge.net/projects/uli-plugins/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND=">=dev-util/lv2-c++-tools-1.0.2"
RDEPEND="${DEPEND}"

src_prepare() {
	# workaround multilib-strict
	sed -i -e "s|/lib/lv2/|/$(get_libdir)/lv2/|" wscript || die
}

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	LINKFLAGS="${LDFLAGS}" ./waf configure --prefix=/usr || die
}

src_compile() {
	./waf build || die
}

src_install() {
	./waf --destdir="${D}" install || die
}
