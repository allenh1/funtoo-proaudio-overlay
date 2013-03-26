# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1

RESTRICT="mirror"
DESCRIPTION="A simple metronome with an easy-to-use GTK interface. "
HOMEPAGE="http://das.nasophon.de/${PN}"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	media-libs/pyliblo[${PYTHON_USEDEP}]
	media-sound/klick[osc]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
