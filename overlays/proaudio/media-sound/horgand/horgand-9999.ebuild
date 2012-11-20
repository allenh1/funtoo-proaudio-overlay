# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit autotools-utils cvs eutils

DESCRIPTION="Opensource software organ"
HOMEPAGE="http://horgand.berlios.de"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ECVS_SERVER="cvs.horgand.berlios.de:/cvsroot/horgand"
ECVS_MODULE="horgand"

RDEPEND="x11-libs/fltk:1
	x11-libs/libXpm
	media-libs/libsndfile
	media-libs/alsa-lib
	media-sound/alsa-utils
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

S="${WORKDIR}/${ECVS_MODULE}"

src_prepare() {
	epatch "${FILESDIR}/${P}-overflow.patch"
	autotools-utils_src_prepare
}

src_configure() {
	autotools-utils_src_configure "CXXFLAGS=$(fltk-config --cxxflags)" \
		"LDFLAGS=$(fltk-config --ldflags)"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
	doman man/${PN}.1
	newicon src/${PN}128.xpm ${PN}.xpm
	make_desktop_entry ${PN} Horgand ${PN}
}
