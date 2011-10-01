# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

DESCRIPTION="jack audio client module for python"
HOMEPAGE="http://py-jack.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/py-jack/py-jack/${PVR}/pyjack-${PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
		media-sound/jack-audio-connection-kit
		dev-lang/python
		"
RDEPEND="${DEPEND}"
