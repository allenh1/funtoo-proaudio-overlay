# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1

DESCRIPTION="Library for windowmaker dockapps using python."
HOMEPAGE="http://pywmdockapps.sourceforge.net/old-index.html"
SRC_URI="http://downloads.sourceforge.net/pywmdockapps/pywmdockapps-${PV}.tar.gz"

IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/pywmdockapps-${PV}"

PATCHES=( "${FILESDIR}/wmdocklib-only.patch" )
