# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Rumpelrausch Täips AZR3 standalone Linux port"
HOMEPAGE="http://ll-plugins.nongnu.org/"
SRC_URI="http://ll-plugins.sourceforge.net/tarballs/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit
		dev-cpp/gtkmm
		media-sound/lash"
RDEPEND="${DEPEND}"

src_compile() {
	./configure \
		--prefix=/usr \
		--CFLAGS="${CFLAGS}" \
		--LDFLAGS="${LDFLAGS}" || die
	emake || die
}

src_install() {
	dobin azr3/azr3
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins azr3/presets
	dodoc AUTHORS README
}
