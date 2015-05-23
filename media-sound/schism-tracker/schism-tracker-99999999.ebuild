# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit mercurial autotools-utils

MY_PN="${PN/-/}"

DESCRIPTION="Schism Tracker"
HOMEPAGE="http://${MY_PN}.org/"
SRC_URI=""
EHG_REPO_URI="http://${MY_PN}.org/hg/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsdl-1.2.8-r1"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF="1"
