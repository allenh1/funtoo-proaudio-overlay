# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_7} )
PYTHON_REQ_USE="tk"
inherit base scons-utils python-r1 toolchain-funcs

DESCRIPTION="An experimental genetic programming synthesiser."
HOMEPAGE="http://www.pawfal.org/Software/fastbreeder/"
SRC_URI="http://www.pawfal.org/Software/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/PyOSC[${PYTHON_USEDEP}]
	>=media-libs/liblo-0.26
	>=media-sound/jack-audio-connection-kit-0.116.2"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

DOCS=( README )

PATCHES=( "${FILESDIR}"/${P}-SConstruct.patch )

src_compile() {
	tc-export CXX
	escons
}

src_install() {
	install_fastbreeder() {
		# osc.py not installed to workaround conflict with media-sound/khagan,
		# provided instead by dev-python/PyOSC
		python_domodule scripts/gpy.py
		python_doscript	scripts/fastbreeder
	}

	python_foreach_impl install_fastbreeder

	dobin fastbreederserver

	base_src_install_docs
}
