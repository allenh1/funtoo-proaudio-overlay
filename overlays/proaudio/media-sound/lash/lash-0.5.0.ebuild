# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/lash/lash-0.5.0.ebuild,v 1.1.1.1 2006/04/10 10:58:08 gimpel Exp $

inherit eutils

IUSE=""

RESTRICT="nomirror"
DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash"
SRC_URI="http://download.savannah.nongnu.org/releases/lash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="media-libs/alsa-lib
	!media-libs/ladcca
	media-sound/jack-audio-connection-kit
	>=x11-libs/gtk+-2.0"

src_unpack() {
	unpack ${P}.tar.gz || die
}

src_compile() {
	econf --disable-serv-inst || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	if ! grep -q ^lash /etc/services; then
		dodir /etc
		insinto /etc
		doins /etc/services
		echo -e "\nlash\t\t14541/tcp\t\t\t# LASH client/server protocol" >> ${D}/etc/services
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	# clean/add to /etc/services if necessary
	if  grep -q ^ladcca /etc/services; then
		 sed -i /ladcca/d /etc/services
	fi
	if ! grep -q ^lash /etc/services; then
		echo -e "\nlash\t\t14541/tcp\t\t\t# LASH client/server protocol" >> /etc/services
	fi
}
