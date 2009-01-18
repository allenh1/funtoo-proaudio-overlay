# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit subversion exteutils

DESCRIPTION="CLAM Music Annotator can visualize, check and modify music information extracted from audio"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI=""
ESVN_REPO_URI="http://iua-share.upf.edu/svn/clam/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"
RESTRICT="nomirror"

DEPEND="dev-util/scons
	dev-util/subversion
	>=media-libs/libclam-9999
	|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-opengl )
			>=x11-libs/qt-4.1:4 )"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

S="${WORKDIR}/${PN}"
QTDIR=""

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr/vmqt
	addpredict /usr/share/clam/sconstools

	cd ${S}/vmqt
	escons clam_prefix=/usr DESTDIR="${D}/usr" release=yes || die "Building vmqt failed"
	cd ${S}
	escons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" release=yes || die "Building Annotator failed"
	convert -resize 48x48 -colors 24 src/images/annotator-icon1.png src/images/clam-annotator.xpm || die "convert icon failed"
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	escons install || die "scons install failed"

	dodoc CHANGES COPYING README todos || die "dodoc failed"

	if use doc; then
		docinto examples/data
		dodoc ${S}/vmqt/examples/data/*
		docinto examples/src
		dodoc ${S}/vmqt/examples/src/*
		docinto examples/utils
		dodoc ${S}/vmqt/examples/utils/*
		docinto examples
		dodoc ${S}/vmqt/examples/README
	fi
	insinto /usr/share/pixmaps
	doins ${S}/src/images/clam-annotator.xpm || die "install icon failed"
}
