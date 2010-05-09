# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI="http://clam.iua.upf.edu/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-util/scons
	>=media-libs/libclam-1.4.0
	<media-libs/libclam-9999
	|| ( ( x11-libs/qt-core x11-libs/qt-gui 
		x11-libs/qt-qt3support x11-libs/qt-opengl )
		>=x11-libs/qt-4:4 )"

RDEPEND="${DEPEND}"

QTDIR=""

pkg_setup() {
	if ! has_version x11-libs/qt-opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
	fi
	if ! has_version x11-libs/qt-qt3support && ! built_with_use =x11-libs/qt-4* qt3support; then
		eerror "You need to build qt4 with qt3support support to have it in ${PN}"
		die "Enabling qt3support for $PN requires qt4 to be built with qt3support support"
	fi
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools

	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Build failed."
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README || die "dodoc failed"

	make_desktop_entry ${PN} Voice2MIDI ${PN} \
		"AudioVideo;Audio;Midi;"

}
