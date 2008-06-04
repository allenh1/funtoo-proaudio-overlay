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
	dev-util/scons
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )
	!media-sound/jack-audio-connection-kit"

src_compile() {
	local myconf="PREFIX=/usr"
	use amd64 && myconfi="${myconf} LIBDIR=/usr/lib64"
	use dbus && myconf="${myconf} ENABLE_DBUS=True"
	use freebob || myconf="${myconf} ENABLE_FREEBOB=False ENABLE_FIREWIRE=False"
	use debug || myconf="${myconf} DEBUG=False"
	use doc || myconf="${myconf} BUILD_DOXYGEN_DOCS=False"
	use examples || myconf="${myconf} BUILD_EXAMPLES=False"
	scons ${myconf} || die
}

src_install() {
	scons PREFIX="/usr" DESTDIR="${D}" install || die
	dodoc Readme Todo ChangeLog
}
