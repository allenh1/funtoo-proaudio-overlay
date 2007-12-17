# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="ASIO driver for WINE"
HOMEPAGE="http://forum.jacklab.net/viewtopic.php?t=417"
SRC_URI="http://people.jacklab.net/edogawa/files/${PN}/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="media-libs/asio-sdk"
RDEPEND=">=app-emulation/wine-0.9.35"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	cp /opt/asiosdk2.2/common/asio.h .
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86
	emake || die "make failed"
}

src_install() {
	exeinto /usr/$(get_libdir)/wine
	doexe *.so
	dodoc README.TXT
}

pkg_postinst() {
	echo
	elog "You need to register the DLL by typing"
	elog
	elog "regsvr32 wineasio.dll"
	elog
	elog "AS THE USER who uses wine!"
	elog "Then open winecfg -> Audio -> and enable ONLY the ALSA driver!"
	echo

	if use amd64; then
		elog "amd64 users please note that ${PN} will not work with 64bit JACK."
		elog "There are two solutions:"
		elog "1) Use a 32bit chroot, and connect the jack instances via netjack"
		elog "   http://thiscow.eu/tiki-index.php?page=linux-amd64-chroot-netjack"
		elog "2) Install emul-linux-x86-jackd and follow the instructions"
	fi
}

