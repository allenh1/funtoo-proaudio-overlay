# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fetch-tools
DESCRIPTION="Schism Tracker cvs"
HOMEPAGE="http://rigelseven.org/schism"
SRC_URI=""
URL="http://nimh.org/schism/cvs-snapshot.tgz"
LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.8-r1"

S="${WORKDIR}/schism2"

src_unpack(){
	fetch_tarball_cmp "${URL}"
	unpack "${URL##*/}"
}

src_compile(){
	mkdir -p build && cd build
	../configure --prefix=/usr --enable-extra-opt || die "configure failed"
	emake || die "emake failed"
}

src_install(){
	cd build
	emake DESTDIR="${D}" install || die
	cd ..
	dodoc README IDEAS TODO ChangeLog AUTHORS
}
