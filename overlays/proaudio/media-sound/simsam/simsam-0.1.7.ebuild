# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions eutils
need-qt 3

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="Simsam is a simple MIDI sample playback program. You can use it to play drum samples and loops from a MIDI keyboard or sequencer"
HOMEPAGE="http://simsam.sourceforge.net"
SRC_URI="mirror://sourceforge/simsam/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=media-libs/alsa-lib-0.9.0
	>=media-sound/jack-audio-connection-kit-0.99
	media-libs/libsndfile 
	media-libs/libsamplerate
	dev-util/pkgconfig"
RDEPEND="${DEPEND}"

src_unpack(){
	unpack "${A}"
	# gcc4-fix
	cd ${S}
	sed -i -e 's/SampleMap\:\://g' lib/instrument.h || die "sed failed"
	sed -i -e 's/InstrumentMap\:\://g' lib/midi.h  || die "sed failed"
	# compile and link fix
	epatch "${FILESDIR}/${P}-gcc3_4.patch.gz"
}

src_compile() {
	econf --with-Qt-dir=$QTDIR || die "confiure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS COPYING README ChangeLog NEWS
}
