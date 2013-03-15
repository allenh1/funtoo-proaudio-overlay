# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit eutils scons-utils toolchain-funcs multilib python-any-r1

DESCRIPTION="A tool for tonal analysis of audio files from the CLAM Project"
HOMEPAGE="http://clam-project.org/"
SRC_URI="http://clam-project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtopengl
	>=media-libs/libclam-1.4.0-r1
	>=media-sound/NetworkEditor-1.4.0-r1"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
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
	QTDIR="${EPREFIX}/usr" escons \
		clam_prefix="${EPREFIX}/usr" \
		prefix="${ED}/usr" \
		qt_plugins_install_path="/$(get_libdir)/qt4/plugins/designer" \
		verbose=1

	convert -resize 48x48 -colors 24 resources/Chordata.ico \
		clam-chordata.xpm || die
}

src_install() {
	QTDIR="${EPREFIX}/usr" escons install

	dodoc CHANGES

	insinto /usr/share/pixmaps
	doins clam-chordata.xpm
}
