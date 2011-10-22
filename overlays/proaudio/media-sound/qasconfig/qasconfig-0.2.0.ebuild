# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

DESCRIPTION="ALSA configuration QT browser"
HOMEPAGE="http://xwmw.org/qasconfig/"
SRC_URI="mirror://sourceforge/qasconfig/0.2.0/${PN}_${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

IUSE=""

DEPEND="media-libs/alsa-lib
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"

S="${WORKDIR}/${PN}_${PV}"

src_compile() {
	mkdir ${S}/build
	cd ${S}/build

	cmake .. -DCMAKE_INSTALL_PREFIX=/usr || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	cd ${S}/build
	emake DESTDIR="${D}" install || die "make install failed"

	cd ${S}
	dodoc README CHANGELOG TODO
}
