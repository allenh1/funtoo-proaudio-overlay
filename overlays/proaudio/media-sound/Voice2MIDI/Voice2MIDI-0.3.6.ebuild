# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI="http://clam.iua.upf.edu/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
RESTRICT="nomirror"

DEPEND="dev-util/scons
	>=media-libs/libclam-1.0.0
	<media-libs/libclam-9999
	=x11-libs/qt-3*"
	
RDEPEND="${DEPEND}"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools
	
	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" || die "Build failed."
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
