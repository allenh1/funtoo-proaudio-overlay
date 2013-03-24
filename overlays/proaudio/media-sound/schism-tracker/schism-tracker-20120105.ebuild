# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils

MY_PN="${PN/-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Schism Tracker"
HOMEPAGE="http://${MY_PN}.org/"
SRC_URI="http://${MY_PN}.org/dl/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"

# Keywording as much as possible, definetely worth a try
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsdl-1.2.8-r1"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF="1"
