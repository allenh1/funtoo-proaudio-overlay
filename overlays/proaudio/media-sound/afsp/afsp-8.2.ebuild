# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

RESTRICT="mirror"

MY_PN="AFsp"
MY_PV="v$(replace_version_separator "1" "r")"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="The AFsp package provides audio file utility programs and a library of routines for reading and writing audio files."
HOMEPAGE="http://www-mmsp.ece.mcgill.ca/Documents/Software/Packages/AFsp/AFsp.html"
SRC_URI="ftp://ftp.tsp.ece.mcgill.ca/TSP/AFsp/${MY_P}.tar.gz"
LICENSE="Unknown"
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
	dodoc Copying  INSTALL.txt  Notes.txt README.txt
}
