# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This is a digital dj mixing software package, aimed towards live music remixing and production."
HOMEPAGE="http://gdam.ffem.org/"
#SRC_URI="mirror:sourceforge.net/gdam/${P}.tar.gz"

inherit cvs
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ECVS_SERVER="gdam.cvs.sourceforge.net:/cvsroot/gdam"
ECVS_MODULE="gdam"

S="${WORKDIR}/${ECVS_MODULE}"

RDEPEND=">=x11-libs/gtk+-2.2.0
	=gnome-base/libglade-0.1*
	>=dev-libs/libxml-1.8
	!gdam-cvs/gdam-cvs"

src_compile() {
	./bootstrap || die "bootstap failed"
	econf || die "Configured Failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
}

pkg_postinst() {
	einfo "Run gdam-server --config /usr/etc/gdam/server-config (Default"
	einfo "configuration) and then gdam-launcher and enjoy"
}
