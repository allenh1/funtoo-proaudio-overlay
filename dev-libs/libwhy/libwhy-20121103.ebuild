# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit waf-utils python-any-r1

DESCRIPTION="A library for developing GTK+ audio applications using Lua"
HOMEPAGE="http://smbolton.com/linux/"
SRC_URI="http://smbolton.com/linux/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# comes bundled with modified lua-5.2.1?
RDEPEND=">=x11-libs/gtk+-2.16.0:2"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(README.rst)

PATCHES=("${FILESDIR}"/${P}-wscript.patch)
