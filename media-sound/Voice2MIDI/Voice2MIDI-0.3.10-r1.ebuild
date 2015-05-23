# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit eutils scons-utils toolchain-funcs python-any-r1

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam-project.org/index.html"
SRC_URI="http://clam-project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libclam-1.4.0-r1
	<media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qt3support
	dev-qt/qtopengl"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

RESTRICT="mirror"

pkg_setup() {
	tc-export CC CXX
	python-any-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch
}

src_compile() {
	QTDIR="${EPREFIX}/usr" escons clam_prefix="${EPREFIX}/usr" \
		prefix="${ED}/usr" verbose=1
}

src_install() {
	QTDIR="${EPREFIX}/usr" escons install

	dodoc CHANGES README

	make_desktop_entry ${PN} Voice2MIDI ${PN} "AudioVideo;Audio;Midi;"
}
