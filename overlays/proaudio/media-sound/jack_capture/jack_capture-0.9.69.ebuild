# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils toolchain-funcs

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
	gtk? ( dev-util/pkgconfig )"

src_compile() {
#	epatch "${FILESDIR}/${P}-Makefile.patch"
	tc-export CC CXX
	make jack_capture prefix=/usr OPTIMIZE="${CFLAGS}" \
		${MAKEOPTS} || die "make jack_capture failed"
	if use gtk; then
		make jack_capture_gui2 CPP="${CXX}" \
			prefix=/usr OPTIMIZE="${CXXFLAGS}" \
			${MAKEOPTS} || die "make jack_capture_gui2 failed"
	fi
}

src_install() {
	dobin jack_capture || die "dobin jack_capture failed"
	if use gtk ; then
		dobin jack_capture_gui2 || die "dobin jack_capture_gui2 failed"
	fi
	dodoc README
}
