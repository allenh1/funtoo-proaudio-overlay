# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="Smack is a drum synth, 100% sample free"
HOMEPAGE="http://smack.berlios.de/"
SRC_URI="http://download.berlios.de/smack/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="media-sound/om
	media-plugins/omins
	media-plugins/swh-plugins
	media-plugins/blop
	media-libs/ladspa-cmt
	media-libs/phat"
	
src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS
}
