# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-20050930.ebuild,v 1.9 2006/01/14 18:39:32 vapier Exp $

inherit eutils
MY_P="ll-scope-${PV}"
DESCRIPTION="An oscilloscope (DSSI-Plugin)"
HOMEPAGE="http://www.student.nada.kth.se/~d00-llu/music_dssi.php?lang=en"
SRC_URI="http://www.student.nada.kth.se/~d00-llu/plugins/ll-scope/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=media-libs/dssi-0.9
	>=dev-cpp/libglademm-2.6.0
	>=media-libs/liblo-0.18
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"
src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/makefile-destdir.patch"
	epatch "${FILESDIR}/${P}-fPIC.patch"
}

src_compile() {
	#econf || die
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
}
