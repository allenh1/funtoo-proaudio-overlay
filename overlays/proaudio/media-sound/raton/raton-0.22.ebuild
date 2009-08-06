# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="mirror"

DESCRIPTION="Mouse driven MIDI controller."
HOMEPAGE="http://home.earthlink.net/~gmoonlit/raton/raton.html"
MY_P="${P/-/_v}"
SRC_URI="http://home.earthlink.net/~gmoonlit/raton/data/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=">=media-libs/alsa-lib-0.9
	>=x11-libs/gtk+-2.4"

src_compile() {
	./autogen.sh --prefix=/usr
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
