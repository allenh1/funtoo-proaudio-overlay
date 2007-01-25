# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/qjackctl/qjackctl-0.2.20.ebuild,v 1.1.1.1 2006/04/10 11:48:19 gimpel Exp $

IUSE=""

inherit eutils kde-functions

RESTRICT=nomirror
DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="virtual/libc
	media-libs/alsa-lib
	=x11-libs/qt-3*
	media-sound/jack-audio-connection-kit"

src_install() {
	einstall || die "make install failed"
}
