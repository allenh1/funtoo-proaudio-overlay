# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion
RESTRICT="mirror"
IUSE=""
DESCRIPTION="Smack is a drum synth, 100% sample free"
HOMEPAGE="http://smack.berlios.de/"
SRC_URI=""
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/smack/trunk"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=">=media-sound/ingen-9999
	>=media-plugins/omins-9999
	media-plugins/swh-plugins
	media-plugins/blop
	media-libs/ladspa-cmt
	media-libs/phat"

src_configure() {
	NOCONFIGURE="1" ./autogen.sh
	econf
}
