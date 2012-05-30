# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils findlib

DESCRIPTION="OCaml deamon tools library."
HOMEPAGE="http://savonet.sourceforge.net"
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="doc"

DEPEND="dev-lang/ocaml
		dev-ml/findlib"

RDEPEND="dev-lang/ocaml"

src_configure() {
	./configure \
		--prefix=/usr || die "./configure failed!"
}

src_install() {
	findlib_src_install

	use doc && dohtml doc/html/*
	dodoc CHANGES README
}
