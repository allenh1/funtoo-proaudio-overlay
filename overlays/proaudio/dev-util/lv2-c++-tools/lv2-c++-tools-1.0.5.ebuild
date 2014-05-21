# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit multilib toolchain-funcs

DESCRIPTION="some tools and libraries that may come in handy when writing LV2 plugins"
HOMEPAGE="http://ll-plugins.nongnu.org/hacking.html"
SRC_URI="http://download.savannah.nongnu.org/releases/ll-plugins/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/gtkmm-2.8.8:2.4
	dev-libs/boost"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

RESTRICT="mirror"

src_prepare() {
	# specify ar
	sed -e 's:ar rcs:$(AR) rcs:' -i Makefile.template || die
	# don't run ldconfig
	sed -e '/ldconfig/d' -i Makefile.template || die
}

src_compile() {
	tc-export AR CXX
	default
	if use doc; then
		doxygen || die "making docs failed"
	fi
}

src_install() {
	default
	if use doc; then
		dohtml -r html/*
	fi
}
