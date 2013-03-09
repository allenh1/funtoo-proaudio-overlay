# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils git-2 qt4-r2

DESCRIPTION="IanniX is a graphical score editor based on the previous UPIC developed by Iannis Xenakis"
HOMEPAGE="http://www.iannix.org/"
EGIT_REPO_URI="https://github.com/${PN}/IanniX.git"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples"

S="${WORKDIR}/IanniX"

DEPEND="${RDEPEND}"
RDEPEND="dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtsql
	dev-qt/qttest
	dev-qt/qtopengl
	dev-qt/qtsvg
	media-libs/freetype
	x11-libs/libSM
	x11-libs/libXrender
	media-libs/mesa
	media-libs/alsa-lib
	x11-libs/gdk-pixbuf"

#pkg_setup() {
#	if ! has_version dev-qt/qtopengl && ! built_with_use =dev-qt/qt-4* opengl; then
#		eerror "You need to build qt4 with opengl support to have it in ${PN}"
#		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
#	fi
#}

src_unpack() {
	git-2_src_unpack
}

src_install() {
	dobin IanniX
	dodoc Readme.txt
	make_desktop_entry IanniX "iannix"
	insinto /usr/share/${PN}
	doins -r Documentation
	doins -r Patches
	doins -r Project
	doins -r Tools
	insinto /usr/share/${PN}/pixmaps
	doins *.png *.ico
	make_wrapper iannix "/usr/bin/IanniX" "/usr/share/${PN}" "/usr/share/${PN},/usr/share/${PN}/pixmaps"

	if use examples; then
		insinto /usr/share/${PN}
		doins -r Examples
	fi
}

pkg_postinst() {
	einfo "You can start IanniX with"
	einfo ""
	einfo "/usr/bin/iannix"
	einfo ""

	if use examples; then
		einfo "The examples have been installed to /usr/share/${PN}/examples"
	fi
	einfo "The documentation is available by clicking on the ? button in IanniX"
}
