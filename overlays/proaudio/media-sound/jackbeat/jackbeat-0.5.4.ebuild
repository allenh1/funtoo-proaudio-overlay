# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/jackbeat/jackbeat-0.5.4.ebuild,v 1.1.1.1 2006/04/10 12:03:08 gimpel Exp $

DESCRIPTION="An audio sequencer for Linux"
HOMEPAGE="http://www.samalyse.com/jackbeat/"
SRC_URI="http://www.samalyse.com/jackbeat/files/${P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit
		>=x11-libs/gtk+-2.0.0
		media-libs/libsndfile
		dev-libs/libxml2
		media-libs/libsamplerate
		media-libs/alsa-lib"

src_install() {
		make DESTDIR=${D} install || die
		dodoc AUTHORS ChangeLog README
}


