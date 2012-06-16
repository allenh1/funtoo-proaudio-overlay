# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils kde

DESCRIPTION="Analyzes, transforms and synthesizes back a given sound using the SMS model."
HOMEPAGE="http://clam.project.org/"

SRC_URI="http://clam.project.org/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~amd64 x86"
IUSE=""
RESTRICT="mirror"
need-kde 3.5

DEPEND="dev-util/scons
	>=media-libs/libclam-1.2.0
	<media-libs/libclam-9999"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

src_unpack() {
	unpack ${A}
}

src_configure() {
	einfo "No configure script"
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools
	addpredict /usr/qt/3/etc/settings/.qt_plugins_3.3rc.lock

	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Build failed"
	convert -resize 48x48 -colors 24 resources/SMSTools-icon.png clam-smstools.xpm || die "Icon convert failed"
}

src_install() {
	cd "${S}"
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README || die "doc install failed"
	insinto /usr/share/pixmaps
	doins clam-smstools.xpm || die "icon install failed"
}
