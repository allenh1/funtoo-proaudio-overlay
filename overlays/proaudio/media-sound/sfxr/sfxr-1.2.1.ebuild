# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Sound effect generator with SDL GUI"
HOMEPAGE="http://www.drpetter.se/project_sfxr.html"
SRC_URI="http://www.drpetter.se/files/${PN}-sdl-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[sound,video]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-sdl-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog readme.txt
}
