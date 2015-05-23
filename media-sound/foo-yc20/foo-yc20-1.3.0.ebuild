# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit multilib

RESTRICT="mirror"
IUSE=""
DESCRIPTION="YC-20 divide-down combo organ emulator with lv2 plugin"
HOMEPAGE="http://code.google.com/p/foo-yc20/"
SRC_URI="http://foo-yc20.googlecode.com/files/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/cairo
	dev-cpp/gtkmm:2.4
	media-sound/jack-audio-connection-kit
	media-libs/lv2
	>=dev-lang/faust-0.9.58"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
