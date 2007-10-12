# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN/-/}"
MY_P="${MY_PN}${PV}"
At="${MY_P}.zip"

DESCRIPTION="Steinberg ASIO SDK 2.2 - win32"
HOMEPAGE="http://www.steinberg.net/329+M52087573ab0.html"
SRC_URI="${At}"

RESTRICT="nostrip fetch"

LICENSE="STEINBERG SOFT-UND HARDWARE GMBH"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
S="${WORKDIR}/ASIOSDK2"

pkg_nofetch() {
	einfo "1. go to ${HOMEPAGE}"
	einfo "2. read the license agreement"
	einfo "3. if you accept it, then download ${At}"
	einfo "4. move ${At} to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack "${At}" || die
}

src_install() {
	cd "${S}"
	dodir "/opt/${MY_P}"
	mv ./* "${D}/opt/${MY_P}"
}

pkg_postinst() {
	echo
	elog "${P} has been installed to /opt/${MY_P}"
	elog "To re-read the license please refer to"
	elog "/opt/${MY_P}/Steinberg ASIO Licensing Agreement.pdf"
	echo
}

