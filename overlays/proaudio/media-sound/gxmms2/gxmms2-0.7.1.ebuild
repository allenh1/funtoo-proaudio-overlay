# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils exteutils

RESTRICT="mirror"
DESCRIPTION="A GTK2 based XMMS2 client, written in C."
HOMEPAGE="http://wejp.k.vu/projects/xmms2/gxmms2"
SRC_URI="http://wejp.k.vu/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND="media-sound/xmms2
	=x11-libs/gtk+-2*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake "${PN}"
}

src_install() {
	dodoc CHANGELOG README
	dobin "${PN}"
	newicon gxmms2src/gxmms2_mini.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "${PN}" "${PN}" "AudioVideo;Audio"
}
