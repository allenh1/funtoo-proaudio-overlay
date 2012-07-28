# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.7"
inherit python distutils

IUSE=""
RESTRICT="mirror"

DESCRIPTION="Live user interface builder for controlling parameters via OSC."
HOMEPAGE="http://khagan.berlios.de/"
SRC_URI="http://download.berlios.de/khagan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-python/pyxml
	>=dev-python/pygtk-2.4
	>=media-libs/pyphat-0.1"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
	dodoc AUTHORS README
}

pkg_postrm() {
	python_mod_cleanup
}
