# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_pre/-pre}

PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"

inherit python distutils

DESCRIPTION="pyliblo is a Python wrapper for the liblo OSC library"
HOMEPAGE="http://das.nasophon.de/pyliblo/"
SRC_URI="http://das.nasophon.de/download/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/liblo-0.26"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.12"

S=${WORKDIR}/${MY_P}
