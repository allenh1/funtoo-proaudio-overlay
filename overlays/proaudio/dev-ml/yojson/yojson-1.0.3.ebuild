# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils findlib

DESCRIPTION="An optimized parsing and printing library for the JSON format."
HOMEPAGE="http://mjambon.com/${PN}.html"
SRC_URI="http://mjambon.com/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml"
DEPEND="${RDEPEND}
		dev-ml/biniou
		dev-ml/cppo
		dev-ml/easy-format"

src_install() {
	dodir /usr/bin
	findlib_src_install BINDIR="${D}usr/bin"
	dodoc Changes README
}
