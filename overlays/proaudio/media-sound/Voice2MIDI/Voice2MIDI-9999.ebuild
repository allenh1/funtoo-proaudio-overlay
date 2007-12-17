# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI=""
ESVN_REPO_URI="http://iua-share.upf.edu/svn/clam/trunk/Voice2MIDI"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="nomirror"

DEPEND="dev-util/scons
	=media-libs/libclam-9999
	=x11-libs/qt-3*"

RDEPEND="${DEPEND}"

S="${WORKDIR}/Voice2MIDI"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools

	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" release=yes || die "Build failed"
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README

	make_desktop_entry ${PN} Voice2MIDI ${PN} \
		"AudioVideo;Audio;Midi;"

}
