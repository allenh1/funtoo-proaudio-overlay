# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils python qt4-r2

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI="http://clam-project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
RESTRICT="mirror"

PYTHON_DEPEND="2:7"

DEPEND=">=media-libs/libclam-1.2.0
	<media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qt3support
	dev-qt/qtopengl"

RDEPEND="${DEPEND}"

QTDIR=""

pkg_setup() {
#	if ! has_version dev-qt/qtopengl && ! built_with_use =dev-qt/qtopengl; then
#		eerror "You need to build qt4 with opengl support to have it in ${PN}"
#		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
#	fi
#	if ! has_version x11-libs/qt-qt3support && ! built_with_use =dev-qt/qt3support; then
#		eerror "You need to build qt4 with qt3support support to have it in ${PN}"
#		die "Enabling qt3support for $PN requires qt4 to be built with qt3support support"
#	fi

	python_set_active_version 2
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr
	addpredict /usr/share/clam/sconstools

	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Build failed."
}

src_install() {
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES README || die "dodoc failed"

	make_desktop_entry ${PN} Voice2MIDI ${PN} \
		"AudioVideo;Audio;Midi;"

}
