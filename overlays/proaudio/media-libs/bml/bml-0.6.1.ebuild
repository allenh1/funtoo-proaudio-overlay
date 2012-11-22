# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils

DESCRIPTION="Buzz Machines Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="app-emulation/wine"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

pkg_postinst() {
	if use amd64; then
		ewarn "AMD64 users please note that you will not be able to load 32bit"
		ewarn "machines! To get some native 64bit ones, install"
		ewarn "media-plugins/buzzmachines"
	fi
}
