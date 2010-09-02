# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4-r2 cvs

DESCRIPTION="QSampler is a graphical frontend to the LinuxSampler engine."
HOMEPAGE="http://qsampler.sourceforge.net"

ECVS_SERVER="qsampler.cvs.sourceforge.net:/cvsroot/qsampler"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="x11-libs/qt-gui:4
	>=media-libs/liblscp-0.5.5
	>=media-libs/libgig-0.3.3
	>=media-sound/linuxsampler-0.4
	media-libs/alsa-lib"

DEPEND="${RDEPEND}"

src_configure() {
	make -f Makefile.cvs
	econf || die "configure failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "einstall failed"
	dodoc AUTHORS ChangeLog README
}
