# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils python

DESCRIPTION="Python bindings to the poppler-qt4"
HOMEPAGE="http://code.google.com/p/python-poppler-qt4"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-text/poppler-0.18.0
	dev-python/sip
	dev-python/PyQt4"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	python setup.py install --root "${D}" \
		|| die "failed to install package"
	python_clean_installation_image -q
}
