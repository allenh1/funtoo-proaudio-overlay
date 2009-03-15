# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.grame.fr/~letz/jack-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug freebob dbus monitor"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1"
DEPEND="${RDEPEND}
	freebob? ( sys-libs/libfreebob )
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )"


S="${WORKDIR}/jack-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	local myconf="--prefix=/usr --destdir=${D}"
	use dbus && myconf="${myconf} --dbus"
	use debug && myconf="${myconf} -d debug"
	use doc && myconf="${myconf} --doxygen"
	use monitor && myconf="${myconf} --monitor"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	./waf --destdir="${D}" install || die "waf install failed"
}
