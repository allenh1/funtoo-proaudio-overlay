# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit subversion exteutils python

DESCRIPTION="CLAM Music Annotator can visualize, check and modify music information extracted from audio"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI=""
ESVN_REPO_URI="http://clam-project.org/clam/trunk"
ESVN_PROJECT="clam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"
RESTRICT="mirror"

PYTHON_DEPEND="2:7"

DEPEND=">=media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtopengl"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

S="${WORKDIR}/${PN}"
MY_S="${S}/${PN}"
QTDIR=""

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr/vmqt
	addpredict /usr/share/clam/sconstools

	cd ${MY_S}/vmqt
	escons clam_prefix=/usr DESTDIR="${D}/usr" release=yes || die "Building vmqt failed"
	cd ${MY_S}
	escons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Building Annotator failed"
	convert -resize 48x48 -colors 24 src/images/annotator-icon1.png src/images/clam-annotator.xpm || die "convert icon failed"
}

src_install() {
	cd ${MY_S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	escons install || die "scons install failed"

	dodoc CHANGES README todos || die "dodoc failed"

	if use doc; then
		docinto examples/data
		dodoc ${MY_S}/vmqt/examples/data/*
		docinto examples/src
		dodoc ${MY_S}/vmqt/examples/src/*
		docinto examples/utils
		dodoc ${MY_S}/vmqt/examples/utils/*
		docinto examples
		dodoc ${MY_S}/vmqt/examples/README
	fi
	insinto /usr/share/pixmaps
	doins ${MY_S}/src/images/clam-annotator.xpm || die "install icon failed"
}
