# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="CLAM's visual builder"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI="http://clam-project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-util/scons
	>=media-libs/libclam-1.3.0
	<media-libs/libclam-9999
 	|| ( ( x11-libs/qt-core x11-libs/qt-gui 
 		x11-libs/qt-xmlpatterns x11-libs/qt-opengl 
		x11-libs/qt-svg )
 		>=x11-libs/qt-4.4:4 )"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

QTDIR=""

pkg_setup() {
	if ! has_version x11-libs/qt-opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
	fi
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools

	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" \
		qt_plugins_install_path="/lib/qt4/plugins/designer" || die "Build failed"
	scons --help
	convert -resize 48x48 -colors 24 src/images/NetworkEditor-icon.png clam-networkeditor.xpm || die "convert NE icon failed"
	convert -resize 48x48 -colors 24 src/images/Prototyper-icon.png clam-prototyper.xpm || die "convert P icon failed"
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README || die "dodoc failed"
	insinto /usr/share/pixmaps
	doins *.xpm || die "install icons failed"
}
