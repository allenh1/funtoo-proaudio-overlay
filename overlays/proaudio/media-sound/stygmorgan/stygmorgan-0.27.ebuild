# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="nls"

RESTRICT="mirror"
DESCRIPTION="stygmorgan is an Interactive Musical Workstation software emulator"
HOMEPAGE="http://stygmorgan.berlios.de"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"

RDEPEND=">=x11-libs/fltk-1.1.2
	>=media-libs/alsa-lib-0.9.0"

DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5-r1 )"

#src_unpack() {
#	unpack ${A}
#	cd ${S}/po
#	sed -i "/mkinstalldirs =/s%.*%mkinstalldirs = ../mkinstalldirs%" Makefile.in.in
#}

src_install() {
	make prefix=${D}/usr localedir=${D}/usr/share/locale install || die
	dodoc AUTHORS NEWS README
}
