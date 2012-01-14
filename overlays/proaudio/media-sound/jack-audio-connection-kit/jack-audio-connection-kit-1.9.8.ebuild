# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.grame.fr/~letz/jack-${PV}.tgz"

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
	# sandbox-1.6 breaks, on amd64 at least

	# paludis...
	if has_version "=sys-apps/sandbox-1.6" && [[ -n $(echo `ps -fp $$`|grep paludis) ]]; then
		eerror "The compile will hang with =sandbox-1.6. Either downgrade to sandbox-1.4, or use"
		eerror "PALUDIS_DO_NOTHING_SANDBOXY=1 paludis -i ${PN}"
		die
	fi

	# portage
	if has "sandbox" ${FEATURES} && ! has "-sandbox" ${FEATURES} && has_version "=sys-apps/sandbox-1.6"; then
		eerror "The compile will hang with =sandbox-1.6. Please use:"
		echo
		eerror "FEATURES=\"-sandbox\" emerge ${PN}"
		echo
		eerror "OR downgrade sandbox to 1.4 at least."
		die
	fi
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
