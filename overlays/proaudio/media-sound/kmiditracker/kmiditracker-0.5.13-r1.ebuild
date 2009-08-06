# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde
RESTRICT="mirror"
DESCRIPTION="MIDI Step Sequencer"
HOMEPAGE="http://www.monasteriomono.org/programs/kmiditracker"
SRC_URI="http://www.monasteriomono.org/programs/kmiditracker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="media-libs/alsa-lib
		kde-base/kdelibs"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -ie "s:${prefix}/share/doc/kde/HTML:${prefix}/share/doc/HTML:g" aclocal.m4
	sed -ie "s:kmiditracker.html:index.html:" src/kmiditracker.desktop
}

need-kde 3
