# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT=nomirror
DESCRIPTION="PHAT is a collection of GTK+ widgets geared toward pro-audio apps."
HOMEPAGE="http://phat.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug doc"

RDEPEND=">=x11-libs/gtk+-2.4
       gnome-base/libgnomecanvas"
DEPEND="${RDEPEND}
       dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	sed -e "s:-Werror::g" -e "s:-O3:${CFLAGS}:g" -i "${S}"/configure
}

src_compile() {
	econf $(use_enable debug) \
	      $(use_enable doc gtk-doc) || die

	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
