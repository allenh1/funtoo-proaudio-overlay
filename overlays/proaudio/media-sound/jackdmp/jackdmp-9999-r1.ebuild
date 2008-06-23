# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/jack2/trunk/jackmp"
RESTRICT="nomirror ccache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc debug examples freebob dbus"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1
	freebob? ( sys-libs/libfreebob )"

DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )"

src_compile() {
	local myconf="--prefix=/usr --destdir=${D}"
	use dbus && myconf="${myconf} --dbus"
	use doc && myconf="${myconf} --doxygen"
	
	einfo "Running \"/waf ${myconf} configure\" ..."
	./waf configure ${myconf} || die "waf failed"
	./waf build ${MAKEOPTS}
}

src_install() {
	./waf install --prefix=/usr --destdir="${D}" || die "waf install failed"
	dodoc Readme Todo ChangeLog
}
