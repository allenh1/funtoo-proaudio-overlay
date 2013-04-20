# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_{6,7} )
inherit distutils-r1

DESCRIPTION="Live user interface builder for controlling parameters via OSC."
HOMEPAGE="http://khagan.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/PyOSC[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.4[${PYTHON_USEDEP}]
	>=media-libs/pyphat-0.1[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

DOCS=( AUTHORS README )

PATCHES=( "${FILESDIR}"/${P}-missing-xml-dom-ext.patch )

python_install() {
	distutils-r1_python_install

	# remove osc.py to prevent conflict with media-sound/fastbreeder, file is
	# provided by dev-python/PyOSC
	rm "${D}$(python_get_sitedir)"/osc.py*
}
