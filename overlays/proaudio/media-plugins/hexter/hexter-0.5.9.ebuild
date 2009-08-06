# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="Yamaha DX7 modeling DSSI plugin"
HOMEPAGE="http://dssi.sourceforge.net/hexter.html"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=media-libs/dssi-0.9
	>=x11-libs/gtk+-2.0
	>=media-libs/ladspa-sdk-1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog TODO README AUTHORS
	}
