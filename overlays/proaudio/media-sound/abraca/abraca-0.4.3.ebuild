# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit exteutils

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://abraca.xmms.se"
SRC_URI="http://abraca.xmms.se/attachments/download/119/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~x86 ~amd64"
RDEPEND="|| (
		>=media-sound/xmms2-0.6
		>=media-sound/xmms2-git-0.6 )
	>=x11-libs/gtk+-2.16.3
	>=dev-lang/vala-0.7.9"
DEPEND="${RDEPEND}
	dev-util/scons"

src_compile() {
	epatch ${FILESDIR}/${P}-site_init.patch
	cd ${P}
	escons \
		$(scons_use_enable doc)
		PREFIX=/usr || die "scons failed"
}

src_install() {
	escons install DESTDIR="${D}" || die "scons install failed"
	dodoc README
}
