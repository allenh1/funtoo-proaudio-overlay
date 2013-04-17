# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="A collection of bridges to LV2 which allows use of LADSPA and DSSI plugins in LV2 hosts"
HOMEPAGE="http://naspro.sourceforge.net/"
SRC_URI="mirror://sourceforge/naspro/naspro/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="media-libs/alsa-lib
	>=media-libs/naspro-core-0.5.0
	>=media-libs/naspro-bridge-it-0.5.0
	>=media-libs/lv2-1.2.0
	>=media-libs/ladspa-sdk-1.13
	>=media-libs/dssi-1.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
