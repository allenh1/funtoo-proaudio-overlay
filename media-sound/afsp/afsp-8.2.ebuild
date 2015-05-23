# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator

RESTRICT="mirror"

MY_PN="AFsp"
MY_PV="v$(replace_version_separator "1" "r")"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="audio file utility programs and library of routines for reading and writing audio files"
HOMEPAGE="http://www-mmsp.ece.mcgill.ca/Documents/Software/Packages/AFsp/AFsp.html"
SRC_URI="http://www-mmsp.ece.mcgill.ca/Documents/Downloads/AFsp/${MY_P}.tar.gz"
LICENSE="AFsp"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	einstall prefix="${D}/usr" || die "emake install failed"
	dodoc Notes.txt README.txt
}
