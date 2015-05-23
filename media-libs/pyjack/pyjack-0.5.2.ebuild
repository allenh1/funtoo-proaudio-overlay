# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
inherit distutils python

DESCRIPTION="jack audio client module for python"
HOMEPAGE="http://py-jack.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/py-jack/py-jack/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
		media-sound/jack-audio-connection-kit
		dev-lang/python
		"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}


if use "examples" ; then
	src_install() {
		distutils_src_install
		insinto ${ROOT}/usr/share/doc/${PF}/examples
		doins demos/*  || die "Cannot install demos"
	}
fi
