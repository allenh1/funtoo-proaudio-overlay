# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit libtool subversion

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
ESVN_REPO_URI="https://www.portaudio.com/repos/portaudio/trunk"
SRC_URI=""

LICENSE="as-is"
SLOT="19"
KEYWORDS=""
IUSE="alsa +cxx debug jack oss static-libs"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_unpack() {
	subversion_src_unpack
}

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
