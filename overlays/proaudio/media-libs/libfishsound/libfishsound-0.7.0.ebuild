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
	cd ${S}
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README || die "Doc install failed."
	dolib.a src/libfishsound/.libs/libfishsound.a || die "Lib install failed"
	dolib.so src/libfishsound/.libs/libfishsound.so.1.1.0 || die "Lib install2 failed."
	rm src/libfishsound/.libs/libfishsound.la
	mv src/libfishsound/.libs/libfishsound.lai src/libfishsound/.libs/libfishsound.la 
	dolib.so src/libfishsound/.libs/libfishsound.la || die "Lib install3 failed"
	dosym /usr/lib/libfishsound.so.1.1.0 /usr/lib/libfishsound.so || die "Dosym2 failed"
	dodir /usr/include/${MY_PN}
	insinto /usr/include/${MY_PN}
	cd include/fishsound
	doins *.h || die "Include install failed"
	cd ${S}
	insinto /usr/lib/pkgconfig
	doins fishsound.pc || die "Fishsound.pc install failed"
}
