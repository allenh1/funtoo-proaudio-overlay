# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets flag-o-matic cvs

DESCRIPTION="FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net"
#SRC_URI="mirror://sourceforge/freqtweak/${P}.tar.gz"

ECVS_SERVER="freqtweak.cvs.sourceforge.net:/cvsroot/freqtweak"
ECVS_MODULE="freqtweak"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/${ECVS_MODULE}

DEPEND="=x11-libs/wxGTK-2.8*
	>=sci-libs/fftw-3.0
	=dev-libs/libsigc++-1.2*
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit"

#src_unpack() {
#	cvs_src_unpack
#	cd "${S}"
#}

src_compile() {
	WX_GTK_VER="2.8"
	need-wxwidgets gtk2

	./autogen.sh
	append-flags -fno-strict-aliasing

	econf \
		--with-wxconfig-path=${WX_CONFIG} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
	make_desktop_entry "${PN}" FreqTweak "${PN}"
}
