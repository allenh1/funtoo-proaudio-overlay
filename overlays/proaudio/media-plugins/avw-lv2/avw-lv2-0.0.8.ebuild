# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=4

PYTHON_DEPEND="2:2.7"
inherit waf-utils python

MY_P=avw.lv2.${PV}
DESCRIPTION="A port of the AMS internal modules to LV2 plugins with VCOs, LFOs, Filters & other modules."
HOMEPAGE="http://sourceforge.net/projects/avwlv2/"
SRC_URI="mirror://sourceforge/avwlv2/${MY_P}.tar.gz"

S=${WORKDIR}/avw.lv2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/lv2"
DEPEND="${RDEPEND}
virtual/pkgconfig
>=x11-libs/gtk+-2.24:2
>=dev-cpp/gtkmm-2.24
>=x11-libs/cairo-1.0.0
>=media-sound/jack-audio-connection-kit-0.120"

DOCS=( "CHANGELOG" )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
