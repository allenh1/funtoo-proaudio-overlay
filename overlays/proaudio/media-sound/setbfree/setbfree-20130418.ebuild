# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit base toolchain-funcs multilib

RESTRICT="mirror"
DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
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

DOCS=( ChangeLog README.md )
PATCHES=(
	"${FILESDIR}/${PN}-multilib-strict-and-cflags.patch"
	"${FILESDIR}/${PN}-respect-ldflags.patch"
)

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
