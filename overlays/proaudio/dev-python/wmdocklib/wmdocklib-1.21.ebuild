# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python distutils eutils

DESCRIPTION="Library for windowmaker dockapps using python."
HOMEPAGE="http://pywmdockapps.sourceforge.net/old-index.html"
SRC_URI="http://downloads.sourceforge.net/pywmdockapps/pywmdockapps-${PV}.tar.gz"

IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_unpack() {
	unpack ${A}
	mv pywmdockapps-${PV} wmdocklib-${PV}
}

src_prepare() {
	epatch "${FILESDIR}/wmdocklib-only.patch"
}
