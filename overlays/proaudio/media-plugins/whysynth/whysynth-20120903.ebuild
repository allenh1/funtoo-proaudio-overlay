# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit autotools-utils

DESCRIPTION="A versatile DSSI Softsynth Plugin"
HOMEPAGE="http://smbolton.com/whysynth.html"
SRC_URI="http://smbolton.com/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND=">=media-libs/dssi-0.9
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/liblo-0.12
	>=sci-libs/fftw-3.2.2:3.0
	>=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig"

src_install() {
	autotools-utils_src_install
	dodoc doc/*
}
