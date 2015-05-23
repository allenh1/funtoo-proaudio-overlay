# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
inherit multilib toolchain-funcs python

DESCRIPTION="Four-band parametric equaliser LV2 plugin"
HOMEPAGE="http://nedko.arnaudov.name/soft/lv2fil/trac/"
SRC_URI="http://nedko.arnaudov.name/soft/lv2fil/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""

RESTRICT="mirror"

DEPEND="|| ( >=media-libs/lv2core-3.0 >=media-libs/lv2-1.0.0 )"
RDEPEND="${DEPEND}
	>=dev-python/pycairo-1.8.8
	>=dev-python/pygtk-2.16.0-r1:2
	>=media-libs/pyliblo-0.8.1"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	tc-export CC CPP CXX AR RANLIB
	./waf configure --lv2-dir=/usr/$(get_libdir)/lv2 \
		|| die "waf configure failed"
}

src_compile() {
	./waf build || die "waf build failed"
}

src_install() {
	./waf --destdir="${D}" install || die "waf install failed"
	dodoc AUTHORS NEWS README
}
