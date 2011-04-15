# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.4 3:3.1"
SUPPORT_PYTHON_ABIS="1"
inherit distutils

DESCRIPTION="pyliblo is a Python wrapper for the liblo OSC library"
HOMEPAGE="http://das.nasophon.de/pyliblo/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/liblo-0.26"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.12"
