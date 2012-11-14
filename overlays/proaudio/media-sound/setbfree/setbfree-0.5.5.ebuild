# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs multilib

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
SRC_URI="http://github.com/downloads/pantherb/setBfree/${P}.tar.gz"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="convolution"

RDEPEND="dev-lang/tcl
	dev-lang/tk
	media-sound/jack-audio-connection-kit
	>=media-libs/alsa-lib-1.0.0
	media-libs/liblo
	media-libs/lv2
	convolution? ( media-libs/libsndfile
		>=media-libs/zita-convolver-3.1.0 )"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(ChangeLog README.md)

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch
	base_src_prepare
}

src_compile() {
	tc-export CC CXX
	base_src_make PREFIX="${EPREFIX}"/usr \
		$(use convolution && echo "ENABLE_CONVOLUTION=yes")
}

src_install() {
	base_src_install $(use convolution && echo "ENABLE_CONVOLUTION=yes") \
		PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)"

	doman doc/*.1

	insinto /usr/share/pixmaps
	doins doc/setBfree.png

	make_desktop_entry setBfree-start setBfree setBfree "AudioVideo;Audio;"
}

pkg_postinst() {
	einfo "Use setBfree-start to run setBfree"
}
