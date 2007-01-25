# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="audio application for live loop manipulation"
HOMEPAGE="http://loopdub.sourceforge.net/"
SRC_URI=""
RESTRICT="nomirror"
inherit cvs

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ECVS_SERVER="loopdub.cvs.sourceforge.net:/cvsroot/loopdub"
ECVS_MODULE="loopdub"


RDEPEND="media-libs/libsdl"

DEPEND="${RDEPEND}"

src_compile() {
	scons || die "scons failed"
}
src_install() {
	make DESTDIR="${D}" install || die "install failed"
	#scons PREFIX=/usr DESTDIR="${D}" install || die "install failed"
	dodoc TODO README INSTALL
}
