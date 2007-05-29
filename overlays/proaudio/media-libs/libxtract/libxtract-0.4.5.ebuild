# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="LibXtract is a simple, portable, lightweight library of audio
feature extraction functions"
HOMEPAGE="http://libxtract.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=sci-libs/fftw-3*"
DEPEND="${RDEPEND}"

src_compile() {
	econf --enable-fft || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README TODO AUTHORS
}


