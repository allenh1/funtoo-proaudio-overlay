# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="debug alsa jack oss"
RESTRICT="nomirror"

DESCRIPTION="Highly flexible and configurable software oscilloscope."
HOMEPAGE="http://flup.homelinux.org/qoscc.html"
SRC_URI="http://flup.homelinux.org/cpp/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

DEPEND="=sci-libs/fftw-3*
	=x11-libs/qt-3*
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"

src_compile() {
	econf \
	$(use_enable debug) \
	$(use_enable alsa) \
	$(use_enable jack) \
	$(use_enable oss) || die

	emake || die
}

src_install (){
	make DESTDIR="${D}" install || die
	dodoc README TODO
}
