# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib

RESTRICT="mirror"
DESCRIPTION="A command line JACK app generating white and pink gaussian noise"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.100"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	sed -i -e 's@g++@\$(CXX)@g' \
		-e '/^CPPFLAGS/ s/-O3//' \
		-e '/^PREFIX/ s@/usr/local@/usr@' \
		-e "/^LIBDIR/ s/lib\$(SUFFIX)/$(get_libdir)/" "${S}/Makefile" \
		|| die "sed of Makefile failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README
}
