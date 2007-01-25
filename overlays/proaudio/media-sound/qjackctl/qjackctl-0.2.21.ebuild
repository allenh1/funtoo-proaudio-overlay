# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils kde-functions

RESTRICT="nomirror"
DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="${RDEPEND}"
RDEPEND="virtual/libc
	media-libs/alsa-lib
	=x11-libs/qt-3*
	media-sound/jack-audio-connection-kit"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry ${PN} "QjackCtl" /usr/share/icons/qjackctl.png
}
