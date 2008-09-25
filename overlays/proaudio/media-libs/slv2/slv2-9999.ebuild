# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils

RESTRICT="nomirror"
IUSE="jack"
DESCRIPTION="SLV2 is a library for LV2 hosts "
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-util/pkgconfig-0.9.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.102.29 )
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.0
	>=sys-libs/raul-9999"

src_compile() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	NOCONFIGURE=1 ./autogen.sh
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
}

