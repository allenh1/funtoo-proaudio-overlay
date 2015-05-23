# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils subversion

DESCRIPTION="QSampler is a graphical frontend to the LinuxSampler engine."
HOMEPAGE="http://qsampler.sourceforge.net"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/qsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="dev-qt/qtgui:4
	>=media-libs/liblscp-0.5.5
	>=media-libs/libgig-0.3.3
	>=media-sound/linuxsampler-0.4
	media-libs/alsa-lib"

DEPEND="${RDEPEND}"

src_configure() {
	make -f Makefile.svn
	econf || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "einstall failed"
	dodoc AUTHORS ChangeLog README
}
