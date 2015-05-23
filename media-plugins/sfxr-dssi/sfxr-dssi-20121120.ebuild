# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit waf-utils python-any-r1

DESCRIPTION="sfxr sound effect generator DSSI plugin"
HOMEPAGE="http://smbolton.com/linux/"
SRC_URI="http://smbolton.com/linux/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libwhy
	media-libs/dssi
	media-libs/liblo
	media-libs/ladspa-sdk
	media-libs/alsa-lib
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(README)

PATCHES=("${FILESDIR}"/${P}-wscript.patch)
