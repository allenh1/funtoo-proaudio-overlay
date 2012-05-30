# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils findlib

DESCRIPTION="A high-level and functional interface to the Format module of the OCaml standard library."
HOMEPAGE="http://mjambon.com/${PN}.html"
SRC_URI="http://mjambon.com/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml"
DEPEND="${RDEPEND}"

src_install() {
	findlib_src_install
	dodoc Changes
}
