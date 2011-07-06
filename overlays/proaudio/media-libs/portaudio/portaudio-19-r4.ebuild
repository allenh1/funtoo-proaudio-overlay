# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit libtool

MY_P=pa_snapshot_v${PV}

DESCRIPTION="A free, cross-platform, open-source, audio I/O library"
HOMEPAGE="http://www.portaudio.com"
SRC_URI="http://portaudio.com/archives/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64 ~ppc ~ppc-macos ~mips"
IUSE="alsa +cxx debug jack oss static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.9 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable debug debug-output) \
		$(use_enable cxx) \
		$(use_enable static-libs static) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with oss)
}

src_compile() {
	emake lib/libportaudio.la || die
	emake || die
}

src_install() {
	default

	find "${D}" -name '*.la' -exec rm -f {} +

	dodoc README.txt
	dohtml index.html
}
