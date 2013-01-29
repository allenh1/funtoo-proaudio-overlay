# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

IUSE="doc examples"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="Faust AUdio STreams is a functional programming language and compiler for fast DSP algorythms"
HOMEPAGE="http://faudiostream.sourceforge.net"
SRC_URI="mirror://sourceforge/faudiostream/${P}.tar.gz"

RDEPEND="sys-devel/bison
		 sys-devel/flex"
DEPEND="sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix prefix
	esed_check -i -e "s\/usr/local\ /usr\ " Makefile
}

src_compile() {
	emake || die "parallel make failed"
}

src_install() {
	make install DESTDIR="${D}"
	dodoc README
	if use doc ; then
	    dodoc WHATSNEW documentation/*.pdf "documentation/additional documentation" || die "install doc failed"
	fi
	if use examples ; then
	    insinto /usr/share/"${P}"/examples
	    doins examples/* || die "install examples failed"
	fi
}
