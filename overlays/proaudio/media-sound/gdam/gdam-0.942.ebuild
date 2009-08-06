# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="This is a digital dj mixing software package, aimed towards live music remixing and production."
HOMEPAGE="http://gdam.ffem.org/"
SRC_URI="mirror://sourceforge/gdam/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86"


RDEPEND=">=x11-libs/gtk+-2.2.0
	=gnome-base/libglade-0.1*
	>=dev-libs/libxml-1.8"

src_compile() {
	econf || die "Configured Failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	einfo "Run gdam-server --config /usr/etc/gdam/server-config (Default"
	einfo "configuration) and then gdam-launcher and enjoy"
}
