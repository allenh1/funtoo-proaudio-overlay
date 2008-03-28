# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 flag-o-matic

DESCRIPTION="free, open source music studio that is conceptionally based on Buzz"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.10
	dev-libs/atk
	x11-libs/pango
	>=gnome-base/libgnomecanvas-2.14.0
	>=media-libs/gstreamer-0.10.11
	media-plugins/gst-buzztard"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	filter-ldflags -Wl,--as-needed --as-needed
	gnome2_src_compile
}
