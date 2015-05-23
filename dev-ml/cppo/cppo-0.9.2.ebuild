# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Equivalent of the C preprocessor targeted at the OCaml language and its variants."
HOMEPAGE="http://mjambon.com/${PN}.html"
SRC_URI="http://mjambon.com/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml"
DEPEND="${RDEPEND}"

src_install() {
	dobin cppo
	dodoc Changes README
}
