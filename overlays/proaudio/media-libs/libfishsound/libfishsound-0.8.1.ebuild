# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libjackasyn/libjackasyn-0.10.ebuild,v 1.10 2004/12/19 05:13:47 eradicator Exp $

IUSE=""

inherit

RESTRICT=nomirror
DESCRIPTION="programming interface for decoding and encoding audio data using \
	Xiph.Org codecs (Vorbis and Speex)"
HOMEPAGE="http://www.annodex.net/software/libfishsound/"
SRC_URI="http://www.annodex.net/software/libfishsound/download/${P}.tar.gz"

LICENSE="CSIRO"
SLOT="0"
KEYWORDS="amd64 sparc x86"

DEPEND="media-libs/speex
	media-libs/libvorbis
	media-libs/liboggz"

MY_PN="fishsound"

src_install() {
	make DESTDIR="${D}" install || die
}
