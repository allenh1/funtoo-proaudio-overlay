# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils

AUTOTOOLS_IN_SOURCE_BUILD="1"

IUSE="nls"

DESCRIPTION="stygmorgan is an Interactive Musical Workstation software emulator"
HOMEPAGE="http://stygmorgan.berlios.de"
SRC_URI="miror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"

DOCS=( AUTHORS README )

RDEPEND=">=x11-libs/fltk-1.1.2
	>=media-libs/alsa-lib-0.9.0"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5-r1 )"
