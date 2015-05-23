# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

DESCRIPTION="A little helper library to develop insert-your-API-here to LV2 bridges"
HOMEPAGE="http://naspro.sourceforge.net/"
SRC_URI="mirror://sourceforge/naspro/naspro/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=media-libs/naspro-core-0.5.0
	>=media-libs/lv2-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
