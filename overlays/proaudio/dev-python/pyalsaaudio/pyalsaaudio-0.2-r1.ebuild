# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# source http://bugs.gentoo.org/show_bug.cgi?id=114526

RESTRICT="nomirror"
inherit distutils

DESCRIPTION="A Python wrapper for the ALSA API"
HOMEPAGE="http://www.sourceforge.net/projects/pyalsaaudio"
SRC_URI="mirror://sourceforge/pyalsaaudio/${P}.tgz"

# perhaps need updated license in licenses?
LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

# virtual python already pulled in by distutils
DEPEND="media-libs/alsa-lib"

src_install() {

	distutils_src_install
	
	# html documentation
	use doc && dohtml -A tex -r doc/*
	
	# install example files
	if use examples; then
		insinto /usr/share/${PN}
		doins *test.py
	fi

}

