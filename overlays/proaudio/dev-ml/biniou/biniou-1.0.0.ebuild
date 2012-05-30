# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils findlib

DESCRIPTION="A binary data format designed for speed, safety, ease of use and backward compatibility."
HOMEPAGE="http://mjambon.com/${PN}.html"
SRC_URI="http://mjambon.com/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml"
DEPEND="${RDEPEND}
		dev-ml/easy-format"

src_compile() {
	emake -j1
}

src_install() {
	dodir /usr/bin
	findlib_src_install	BINDIR="${D}usr/bin"
	dodoc Changes
}
