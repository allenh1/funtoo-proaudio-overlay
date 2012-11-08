# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit multilib python

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="https://dl.dropbox.com/u/28869550/jack-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus debug doc freebob ieee1394 32bit"

RDEPEND="dev-util/pkgconfig"

DEPEND="${RDEPEND}
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )"

S="${WORKDIR}/jack-${PV}/jack-${PV}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
# Fix for waf to use python2, since waf is not compatible with phyton3
cd ${S}
	for x in $(grep -r "/usr/bin/env python" * | cut -f1 -d":" ); do
		einfo "Tweaking $x for python2..."
		sed -e "s:/usr/bin/env python:/usr/bin/env python2:g" -i $x
	done
}

src_configure() {
	local myconf="--prefix=/usr --destdir=${D}"
	use alsa && myconf="${myconf} --alsa"
	use dbus && myconf="${myconf} --dbus"
	! use dbus && myconf="${myconf} --classic"
	use debug && myconf="${myconf} -d debug"
	use doc && myconf="${myconf} --doxygen"
	use freebob && myconf="${myconf} --freebob"
	use ieee1394 && myconf="${myconf} --firewire"
	use 32bit && myconf="${myconf} --mixed"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
}

src_compile() {
	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	ln -s ../../html build/default/html
	./waf --destdir="${D}" install || die "waf install failed"
}
