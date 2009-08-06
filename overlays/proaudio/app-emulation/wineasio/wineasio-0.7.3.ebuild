# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

WINEASIOX="wineasio-x.3"

DESCRIPTION="ASIO driver for WINE"
HOMEPAGE="http://forum.jacklab.net/viewtopic.php?t=417"
SRC_URI="x86? ( http://people.jacklab.net/drumfix/${P}.tar.bz2 )
amd64? ( http://people.jacklab.net/drumfix/${WINEASIOX}.tgz )"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="media-libs/asio-sdk"
RDEPEND=">=app-emulation/wine-0.9.35"

if use amd64; then
	S="${WORKDIR}/${WINEASIOX}"
fi

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp /opt/asiosdk2.2/common/asio.h .
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	# need to be a bit tricky here
	local mylibdir="lib"
	use amd64 && mylibdir="lib32"

	exeinto /usr/${mylibdir}/wine
	doexe *.so
	dodoc README.TXT readme.txt
	use amd64 && dobin jackbridge
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
		elog "For amd64 users:"
		elog "You need to start jackbridge and make jack connections"
		elog "before starting any wineasio application!"
		elog "The jackbridge bridges 32bit wineasio clients into 64bit jack"
	fi
}

