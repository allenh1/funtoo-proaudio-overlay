# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ASIO driver for WINE"
HOMEPAGE="http://forum.jacklab.net/viewtopic.php?t=417"
SRC_URI="http://people.jacklab.net/drumfix/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/asio-sdk"
RDEPEND=">=app-emulation/wine-0.9.35"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	cp /opt/asiosdk2.2/common/asio.h .
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	exeinto /usr/lib/wine
	doexe *.so
	dodoc README.TXT
}

pkg_postinst() {
	elog "You need to register the DLL by typing"
	elog 
	elog "regsvr32 wineasio.dll"
	elog
	elog "AS THE USER who uses wine!"
}

