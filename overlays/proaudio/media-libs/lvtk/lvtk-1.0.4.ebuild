# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit waf-utils python-single-r1

RESTRICT="mirror"
DESCRIPTION="A set C++ wrappers around the LV2 C API."
HOMEPAGE="http://lvtoolkit.org/"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
media-libs/lv2
>=dev-cpp/gtkmm-2.4
>=dev-libs/boost-1.40.0
${PYTHON_DEPS}"
DEPEND="${RDEPEND}
virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )
