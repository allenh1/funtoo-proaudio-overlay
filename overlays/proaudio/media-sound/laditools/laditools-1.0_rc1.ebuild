# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils

MY_P="${P/_/-}"

DESCRIPTION="LADITools is a set of tools to improve desktop integration and user workflow of Linux audio systems"
HOMEPAGE="http://www.marcochapeau.org/software/laditools"
SRC_URI="http://www.marcochapeau.org/files/laditools/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/python
	dev-python/pygtk
	dev-python/pyxml
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]
	>=media-sound/lash-0.6.0_rc2
	x11-libs/vte"
DEPEND="dev-lang/python"

S="${WORKDIR}/${MY_P}"

DOCS="README"

src_prepare() {
	epatch "${FILESDIR}/${P}-no_extra_docs.patch"
}
