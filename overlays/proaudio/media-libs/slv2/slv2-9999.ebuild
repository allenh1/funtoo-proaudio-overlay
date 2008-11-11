# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion exteutils

RESTRICT="nomirror"
IUSE="debug doc"
DESCRIPTION="SLV2 is a library for LV2 hosts "
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-util/pkgconfig-0.9.0
	>=media-sound/jack-audio-connection-kit-0.102.29
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.0
	>=media-libs/raul-9999"

src_compile() {
	cd "${S}/${PN}" || die "source for ${PN} not found"

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"
	
	./waf configure ${myconf} || die "configure failed"
	./waf build ${MAKEOPTS} || die "waf failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog
}

