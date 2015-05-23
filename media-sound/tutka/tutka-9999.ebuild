# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/tutka/tutka-0.12.3.ebuild,v 1.1 2006/04/10 17:19:53 gimpel Exp $

EAPI=5
inherit eutils git-2 qt4-r2

RESTRICT="mirror"
IUSE="" #jack" # lash" # cairo"
DESCRIPTION="A free (as in freedom) tracker style MIDI sequencer for GNU/Linux"
HOMEPAGE="http://www.nongnu.org/tutka"
EGIT_REPO_URI="git://git.sv.gnu.org/${PN}.git"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""

DEPEND=">=media-libs/alsa-lib-0.9.0
	dev-qt/qtcore
	dev-qt/qtgui"
#	jack? ( >=media-sound/jack-audio-connection-kit-0.90.0 )"

DOCS=( AUTHORS NEWS README TODO )

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	qt4-r2_src_install
	doicon -s 48 "${FILESDIR}"/Tutka.xpm
	make_desktop_entry Tutka Tutka Tutka.xpm "AudioVideo;Audio;Sequencer"
}
