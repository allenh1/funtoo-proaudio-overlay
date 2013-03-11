# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2} )
inherit distutils-r1

MY_P="python"
MY_PN="${MY_P}_alsaplayer"

RESTRICT="mirror"

DESCRIPTION="New Python bindings for Alsaplayer."
HOMEPAGE="http://alsaplayer.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsaplayer/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${MY_P}"

RDEPEND="media-sound/alsaplayer
	dev-libs/boost[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README )
PATCHES=(
	"${FILESDIR}/${P}-undefined.patch"
	"${FILESDIR}/${P}-libboost.patch"
)
