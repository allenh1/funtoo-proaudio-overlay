# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zyn3
RESTRICT="mirror"
MY_P="unsorted_${PN/-extras/}Parameters${PV}"
MY_PN="zynaddsubfx"
DESCRIPTION="unsorted bank/instruments and parameters for zynaddsubfx"
HOMEPAGE="http://zynaddsubfx.sourceforge.net"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${MY_P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""
DEPEND="${RDEPEND}
	app-arch/unzip"
RDEPEND="|| ( >=media-sound/zynaddsubfx-2.2.1-r4 media-sound/yoshimi )"

S="${WORKDIR}/*zynaddsubfx"*
pkg_setup(){
	use_smart
}

src_unpack(){
	unpack ${A}
	cd "${S}"
	find -name 'CVS' -exec rm -rf {} \; &>/dev/null
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	unsorted="/usr/share/${MY_PN}/banks/unsorted"
	examples="/usr/share/${MY_PN}/examples"
	dodir   "${unsorted}" "${examples}"
	for dir in `find -maxdepth 1 -type d`;do
		mv "${dir}"/*.xiz "${D}${unsorted}" &>/dev/null
	done
	fowners -R root:root  "${unsorted}"
	fperms -R 644 "${unsorted}"

	insinto "${examples}"
	doins -r ../*zynaddsubfx*
}

pkg_postinst() {
	einfo "This packages provides unsorted bank/instruments for zynaddsubfx in:"
	einfo "${unsorted}"
	einfo "and also  a lot of unsorted *.xmz parameters in:"
	einfo "${examples}"
}
