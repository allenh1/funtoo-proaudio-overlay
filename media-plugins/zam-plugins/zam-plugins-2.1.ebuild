# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils toolchain-funcs multilib

DESCRIPTION="Collection of LV2/LADSPA audio plugins for high quality processing"
HOMEPAGE="http://www.zamaudio.com/?p=870"
# snapshot of git repo with pulled submodules copied to proaudio distfiles
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/zam-plugins-2.1-13-gdaa2b87.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-util/lv2-c++-tools
	dev-lang/faust
	media-libs/lv2
	media-libs/ladspa-sdk
	virtual/pkgconfig"

S=${WORKDIR}/zam-plugins-2.1-13-gdaa2b87

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)" DESTDIR="${D}" install
}
