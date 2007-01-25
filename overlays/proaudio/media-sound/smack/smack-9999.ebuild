# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion
RESTRICT="nomirror"
IUSE=""
DESCRIPTION="Smack is a drum synth, 100% sample free"
HOMEPAGE="http://smack.berlios.de/"
SRC_URI=""
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/smack/trunk"

LICENSE="GPL-2"
KEYWORDS="-*"

DEPEND="=media-sound/om-9999
	media-plugins/omins
	media-plugins/swh-plugins
	media-plugins/blop
	media-libs/ladspa-cmt
	media-libs/phat"
	
src_compile() {
	NOCONFIGURE="1" ./autogen.sh
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS
}
