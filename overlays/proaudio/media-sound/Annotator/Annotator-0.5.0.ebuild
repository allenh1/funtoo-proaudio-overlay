# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit exteutils python

DESCRIPTION="CLAM Music Annotator can visualize, check and modify music information extracted from audio"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI="http://clam-project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

PYTHON_DEPEND="2:7"

DEPEND=">=media-libs/libclam-1.4.0
	<media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtopengl:4"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

QTDIR=""

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr/vmqt
	addpredict /usr/share/clam/sconstools

	cd "${S}"/vmqt
	escons clam_prefix=/usr DESTDIR="${D}/usr" release=yes || die "Building vmqt failed"
	cd "${S}"
	escons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Building Annotator failed"
	convert -resize 48x48 -colors 24 src/images/annotator-icon1.png src/images/clam-annotator.xpm || die "convert icon failed"
}

src_install() {
	dodir /usr
	addpredict /usr/share/clam/sconstools

	escons install || die "scons install failed"

	dodoc CHANGES README todos  || die "dodoc failed"

	if use doc; then
		docinto examples/data
		dodoc "${S}"/vmqt/examples/data/*
		docinto examples/src
		dodoc "${S}"/vmqt/examples/src/*
		docinto examples/utils
		dodoc "${S}"/vmqt/examples/utils/*
		docinto examples
		dodoc "${S}"/vmqt/examples/README
	fi
	insinto /usr/share/pixmaps
	doins "${S}"/src/images/clam-annotator.xpm || die "install icon failed"
}
