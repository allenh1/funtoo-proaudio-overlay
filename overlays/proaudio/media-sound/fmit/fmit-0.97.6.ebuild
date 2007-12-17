# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/fmit/fmit-0.96.5-r1.ebuild,v 1.1 2006/04/10 16:16:23 gimpel Exp $

inherit kde-functions eutils
need-qt 3

RESTRICT="nomirror"

DESCRIPTION="Free Music Instrument Tuner"
SRC_URI="http://download.gna.org/fmit/${P}.tar.bz2"
HOMEPAGE="http://home.gna.org/fmit/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"

IUSE="alsa doc jack debug"

DEPEND=">=x11-libs/qt-3.2.0
	alsa? ( >=media-libs/alsa-lib-1.0.3 )
	|| ( virtual/x11 x11-base/xorg-server )
	jack? ( >=media-sound/jack-audio-connection-kit-0.94.0 )
	|| ( media-libs/glut media-libs/freeglut media-libs/mesa )"


src_compile() {
	 [ -e /var/db/pkg/media-libs/mesa* ] && mesa="--enable" || mesa="--disable"
	einfo ${mesa/--/}
	econf ${mesa}-Mesa `use_enable jack` `use_enable alsa` `use_enable debug` \
	|| die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
