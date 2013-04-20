# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base eutils toolchain-funcs

DESCRIPTION="Recording tool which default operation is to capture what goes out to the soundcard from JACK"
HOMEPAGE="http://www.notam02.no/arkiv/src"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk"

RDEPEND=">=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.100
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )"

PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )
DOCS=( README )

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}/usr" jack_capture
	use gtk && emake PREFIX="${EPREFIX}/usr" jack_capture_gui2
}

src_install() {
	dobin jack_capture
	use gtk && dobin jack_capture_gui2
	base_src_install_docs
}
