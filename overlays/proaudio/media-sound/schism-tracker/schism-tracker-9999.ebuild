# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools cvs

DESCRIPTION="Schism Tracker cvs"
HOMEPAGE="http://rigelseven.org/schism"
SRC_URI=""
ECVS_SERVER="schismtracker.cvs.sourceforge.net:/cvsroot/schismtracker"
ECVS_MODULE="schism2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2.8-r1"

DEPEND="${RDEPEND}"

S="${WORKDIR}/schism2"

#src_unpack(){
#	fetch_tarball_cmp "${URL}"
#	unpack "${URL##*/}"
#}

src_prepare() {
	eaclocal || die
	eautoheader || die
	WANT_AUTOMAKE=latest eautomake || die
	WANT_AUTOCONF=latest eautoconf || die
}

src_compile(){
	#mkdir -p build && cd build
	#../configure --prefix=/usr --enable-extra-opt || die "configure failed"
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die
	dodoc README NEWS TODO ChangeLog AUTHORS
}
