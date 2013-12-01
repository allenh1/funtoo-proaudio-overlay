# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="a set of tools to improve desktop integration and user workflow of Linux audio systems"
HOMEPAGE="https://launchpad.net/laditools"
SRC_URI="https://launchpad.net/${PN}/1.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wmaker"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/enum-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]
	>=x11-libs/gtk+-3.2.2:3[introspection]
	>=x11-libs/vte-0.30.1:2.90[introspection]
	wmaker? ( dev-python/wmdocklib[${PYTHON_USEDEP}] )"
DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

pkg_preinst() {
	# A small hack to remove all wmladi files. This is needed because
	# the ebuild should not rely on the python-r1 eclasses' internal
	# wrappings.
	if ! use wmaker ; then
		local files=$(find "${D}" | grep wmladi)
		for file in ${files}; do
			einfo "Removing ${file} due to USE='-wmaker'"
			rm ${file}
		done
	fi
}
