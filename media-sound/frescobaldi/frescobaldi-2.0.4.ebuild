# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils python

DESCRIPTION="a LilyPond sheet music text editor"
HOMEPAGE="http://www.frescobaldi.org"
SRC_URI="mirror://github/wbsoft/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="portmidi"

DEPEND="dev-python/PyQt4[X]"
RDEPEND="${DEPEND}
	dev-python/python-poppler-qt4
	media-sound/lilypond
	portmidi? ( media-libs/portmidi )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	python setup.py build \
		|| die "failed to build package"
}

src_install() {
	python setup.py install --root "${D}" \
		|| die "failed to install package"
	python_clean_installation_image -q
}
