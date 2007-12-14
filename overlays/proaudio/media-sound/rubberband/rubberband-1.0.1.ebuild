# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility
program"
HOMEPAGE="http://www.breakfastquay.com/rubberband/"
SRC_URI="http://www.breakfastquay.com/rubberband/files/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=sci-libs/fftw-3*
	media-libs/libsndfile
	media-libs/vamp-plugin-sdk
	media-libs/libsamplerate
	media-libs/ladspa-sdk"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make \
		INSTALL_BINDIR="${D}/usr/bin" \
		INSTALL_INCDIR="${D}/usr/include/rubberband" \
		INSTALL_LIBDIR="${D}/usr/$(get_libdir)" \
		INSTALL_VAMPDIR="${D}/usr/$(get_libdir)/vamp" \
		INSTALL_LADSPADIR="${D}/usr/$(get_libdir)/ladspa" \
		INSTALL_PKGDIR="${D}/usr/$(get_libdir)/pkgconfig" \
		install || die
	dodoc README
}
