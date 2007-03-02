# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit cvs eutils kde-functions

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI=""
S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="virtual/libc
	media-libs/alsa-lib
	=x11-libs/qt-3*
	media-sound/jack-audio-connection-kit"

src_unpack() {
	ECVS_SERVER="qjackctl.cvs.sourceforge.net:/cvsroot/qjackctl"
	ECVS_USER="anonymous"
	ECVS_PASS=""
	ECVS_AUTH="pserver"
	ECVS_MODULE="qjackctl"
	ECVS_TOP_DIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"
	cvs_src_unpack
}

src_compile() {
	make -f Makefile.cvs
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry ${PN} "QjackCtl" /usr/share/icons/qjackctl.png
}
