# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion qt4

DESCRIPTION="CLAM's visual builder"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI=""
ESVN_REPO_URI="http://iua-share.upf.edu/svn/clam/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="nomirror"

RDEPEND="dev-util/scons
	=media-libs/libclam-9999
    	=x11-libs/qt-4*"
	
DEPEND="${DEPEND}
	media-gfx/imagemagick"

QTDIR=""

S="${WORKDIR}/${PN}"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools
		    
	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" \
		qt_plugins_install_path="/lib/qt4/plugins/designer" || die "Build failed"
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
