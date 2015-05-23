# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit unpacker
RESTRICT="mirror"
MY_PN="zynaddsubfx"
DESCRIPTION="user contributed instruments for zynaddsubfx"
HOMEPAGE="http://proaudio.tuxfamily.org/files"
SRC_URI="http://proaudio.tuxfamily.org/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""
RDEPEND="|| ( >=media-sound/zynaddsubfx-2.2.1-r4 media-sound/yoshimi )"
DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${A}
	mkdir -p "$S" ; cd "${S}"
	unpacker "${WORKDIR}"/*.tar.*
	find -name 'CVS' -exec rm -rf {} \; &>/dev/null
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	banks_collection="/usr/share/${MY_PN}/banks/"
	dodir "${banks_collection}"
	fowners -R root:root  "${banks_collection}"
	fperms -R 600 "${banks_collection}"
	fperms 755 "${banks_collection}"

	insinto "${banks_collection}"
	doins -r "${S}"/*
	dodoc ../README ../ChangeLog
}

pkg_postinst() {
	einfo "This packages provides various user contributed instruments for zynaddsubfx"
}
