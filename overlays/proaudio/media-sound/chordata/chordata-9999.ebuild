# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit exteutils qt4-r2 subversion

DESCRIPTION="Chordata is a tool for tonal analysis of audio files."
HOMEPAGE="http://clam-project.org/"
ESVN_REPO_URI="http://clam-project.org/clam/trunk/chordata/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=media-libs/libclam-9999
	>=media-sound/NetworkEditor-1.4.0
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtopengl"

DEPEND="${RDEPEND}
	dev-util/scons"

QTDIR=""

src_compile() {
#	# required for scons to "see" intermediate install location
	mkdir -p "${D}/usr"
	addpredict /usr/share/clam/sconstools

	escons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes \
		qt_plugins_install_path="/lib/qt4/plugins/designer" || die "Building chordata failed"
	convert -resize 48x48 -colors 24 resources/Chordata.ico clam-chordata.xpm || die "convert icon failed"
}

src_install() {
	dodir /usr
	addpredict /usr/share/clam/sconstools

	escons install || die "scons install failed"

	dodoc CHANGES || die "dodoc failed"

	insinto /usr/share/pixmaps
	doins clam-chordata.xpm || die "install icon failed"
}
