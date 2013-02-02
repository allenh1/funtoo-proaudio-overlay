# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit waf-utils python-single-r1

MY_P="avw.lv2-${PV}"
DESCRIPTION="A port of the AMS internal modules to LV2 plugins with VCOs, LFOs, Filters & other modules."
HOMEPAGE="http://sourceforge.net/projects/avwlv2/"
SRC_URI="mirror://sourceforge/avwlv2/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
media-libs/lv2
>=media-libs/lvtk-1.0.3"
DEPEND="${RDEPEND}
virtual/pkgconfig
>=x11-libs/gtk+-2.24:2
>=x11-libs/cairo-1.0.0
>=media-sound/jack-audio-connection-kit-0.120"

DOCS=( CHANGELOG README THANKS TODO )
PATCHES=( "${FILESDIR}/${P}-replace-std-c++11.patch" )
