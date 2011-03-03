# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

inherit multilib eutils subversion # autotools

DESCRIPTION="wavpack experimental input plugin for the alsaplayer."
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ESVN_REPO_URI="https://alsaplayer.svn.sourceforge.net/svnroot/alsaplayer/trunk/experimental/wv"

S=${WORKDIR}/${PN}

DEPEND=">=media-sound/alsaplayer-9999"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	PREFIX="${D}/usr" emake || die "make failed"
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/alsaplayer/input"
	PREFIX="${D}/usr" emake DESTDIR="${D}" install \

#	dodoc AUTHORS ChangeLog README
	einfo "This plugin is very experimental"
}
