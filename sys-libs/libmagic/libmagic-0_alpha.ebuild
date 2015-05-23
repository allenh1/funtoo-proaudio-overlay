# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils versionator

MY_PV="alpha"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Lbrary for automatically determining the type of a file by performing a series of tests on it."
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="sys-apps/file"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	dolib.a libmagic.a
	dodoc README
}
