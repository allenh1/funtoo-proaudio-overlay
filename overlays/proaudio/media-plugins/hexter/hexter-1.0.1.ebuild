# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils

DESCRIPTION="Yamaha DX7 modeling DSSI plugin"
HOMEPAGE="http://dssi.sourceforge.net/hexter.html"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="float gtk ncurses"

RDEPEND="media-libs/alsa-lib
	>=media-libs/dssi-0.4
	>=media-libs/liblo-0.12
	gtk? ( x11-libs/gtk+:2 )
	ncurses? ( sys-libs/ncurses
			   sys-libs/readline )"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
	virtual/pkgconfig"

RESTRICT="mirror"

AUTOTOOLS_AUTORECONF=1

DOCS=(AUTHORS ChangeLog README TODO)

src_prepare() {
	# aggressive flags need looking at
	sed -i -e "s/-fomit-frame-pointer//g" configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable float floating-point)
		$(use_with gtk gtk2)
		$(use_with ncurses textui)
	)
	autotools-utils_src_configure
}
