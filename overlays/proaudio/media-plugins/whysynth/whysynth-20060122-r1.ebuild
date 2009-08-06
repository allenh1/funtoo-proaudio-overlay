# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="WhySynth is a versatile softsynth using (DSSI)"
HOMEPAGE="http://home.jps.net/~musound/whysynth.html"
SRC_URI="http://home.jps.net/~musound/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=media-libs/dssi-0.9
	>=x11-libs/gtk+-2.0
	=sci-libs/fftw-3*
	dev-util/pkgconfig
	>=media-libs/liblo-0.12
	>=media-libs/ladspa-sdk-1.0"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	epatch "${FILESDIR}/whysynth_hacked_eg.patch"
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	#dodoc ANNOUNCE AUTHORS BUGS ChangeLog DEVELOPERS-HINTS README
}
