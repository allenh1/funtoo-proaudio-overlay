# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="Faust AUdio STreams is a functional programming language for realtime audio plugins and applications development. The Faust compiler translates signal processing specifications into C++ code."
HOMEPAGE="http://faudiostream.sourceforge.net"
SRC_URI="mirror://sourceforge/faudiostream/${P}b.tar.gz"

RDEPEND="sys-devel/bison
		 sys-devel/flex"
DEPEND="sys-apps/sed"

src_compile() {
	sed -i "s\/usr/local\ /usr\ " Makefile
	emake || die "parallel make failed"
}

src_install() {
	make install DESTDIR="${D}"
	dodoc README 
	insinto /usr/share/doc/"${P}"
	use doc doins faust_tutorial.pdf
}
