# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit vstplugin

DESCRIPTION="Linux port of Paul Kellet's mda plugin collection"
HOMEPAGE="http://www.linux-vst.com/"
SRC_URI="http://www.energy-xt.com/download/mda_linux.tar.gz"
RESTRICT="mirror"

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

