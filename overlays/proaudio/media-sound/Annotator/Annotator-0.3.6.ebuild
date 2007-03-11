# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CLAM Music Annotator can visualize, check and modify music information extracted from audio"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI="http://clam.iua.upf.edu/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"
RESTRICT="nomirror"

DEPEND="dev-util/scons
	media-libs/libclam
    	>=x11-libs/qt-4.1"
	
RDEPEND="${DEPEND}"

QTDIR="/usr"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr/vmqt
	addpredict /usr/share/clam/sconstools
		    
	cd ${S}/vmqt
	scons clam_prefix=/usr DESTDIR="${D}/usr" -j2
	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" -j2
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools
	
	scons install || die "scons install failed"
	
	dodoc CHANGES COPYING README todos 

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
}
