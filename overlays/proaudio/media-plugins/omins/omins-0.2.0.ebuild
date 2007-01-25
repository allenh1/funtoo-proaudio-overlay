# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="Omins is a collection of LADSPA plugins geared at modular
synthesizers"
HOMEPAGE="http://www.nongnu.org/om-synth/omins.html"
SRC_URI="http://savannah.nongnu.org/download/om-synth/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk
	sci-libs/fftw"

src_compile() {
	econf --prefix=${D}/usr|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc NEWS AUTHORS README ChangeLog
}
