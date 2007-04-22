# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit vstplugin

DESCRIPTION="Linux version of Jezar's reverb plugin"
HOMEPAGE="http://www.linux-vst.com/"
SRC_URI="http://www.linux-vst.com/download/freeverb.tar.gz"
RESTRICT="nomirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""
S="${WORKDIR}"

src_install() {
	dodir /usr/lib/vst
	insinto /usr/lib/vst
	doins *.so
}

