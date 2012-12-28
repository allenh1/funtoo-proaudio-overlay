# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT="python2_7"

inherit git-2 python-r1 distutils-r1

DESCRIPTION="Control and monitor a LADI system the easy way"
HOMEPAGE="https://launchpad.net/laditools"
EGIT_REPO_URI="git://repo.or.cz/laditools.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/python
	>=dev-python/pygtk-2.12
	dev-python/pyxdg
	>=dev-python/enum-0.4.4
	>=dev-python/pygobject-3.0.0
	dev-python/pyxml
	>=x11-libs/gtk+-3.0.0[introspection]
	x11-libs/vte[introspection]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]"
DEPEND="dev-python/python-distutils-extra"
