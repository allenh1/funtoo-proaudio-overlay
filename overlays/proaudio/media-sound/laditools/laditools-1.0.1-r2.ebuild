# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="LADITools is a set of tools to improve desktop integration and user workflow of Linux audio systems"
HOMEPAGE="http://www.marcochapeau.org/software/laditools"
SRC_URI="https://launchpad.net/${PN}/1.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wmaker"

RDEPEND="
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/enum-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	wmaker? ( dev-python/wmdocklib[${PYTHON_USEDEP}] )
	>=x11-libs/gtk+-3.0.0[introspection]
	x11-libs/vte[introspection]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]"
DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

pkg_preinst() {
	if ! use wmaker ; then
		rm "${D}"/usr/bin/wmladi || die "rm wmladi failed"
		rm "${D}"/usr/bin/wmladi-python2.7 || die "rm wmladi-python2.7 failed"
	fi
}
