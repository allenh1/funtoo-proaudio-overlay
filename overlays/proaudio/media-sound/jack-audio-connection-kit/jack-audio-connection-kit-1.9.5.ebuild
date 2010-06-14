# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.grame.fr/~letz/jack-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug freebob dbus 32bit"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1"
DEPEND="${RDEPEND}
	freebob? ( sys-libs/libfreebob )
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )"

S="${WORKDIR}/jack-${PV}"

pkg_setup() {
	# sandbox-1.6 breaks, on amd64 at least

	# paludis...
	if has_version "=sys-apps/sandbox-1.6" && [[ -n $(echo `ps -fp $$`|grep paludis) ]]; then
		eerror "The compile will hang with =sandbox-1.6. Either downgrade to sandbox-1.4, or use"
		eerror "PALUDIS_DO_NOTHING_SANDBOXY=1 paludis -i ${PN}"
		die
	fi
	
	# portage
	if hasq "sandbox" ${FEATURES} && ! hasq "-sandbox" ${FEATURES} && has_version "=sys-apps/sandbox-1.6"; then
		eerror "The compile will hang with =sandbox-1.6. Please use:"
		echo
		eerror "FEATURES=\"-sandbox\" emerge ${PN}"
		echo
		eerror "OR downgrade sandbox to 1.4 at least."
		die
	fi
}

src_compile() {
	local myconf="--prefix=/usr --destdir=${D}"
	use dbus && myconf="${myconf} --dbus"
	!use dbus && myconf="${myconf} --classic"
	use debug && myconf="${myconf} -d debug"
	use doc && myconf="${myconf} --doxygen"
	use 32bit && myconf="${myconf} --mixed"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	./waf --destdir="${D}" install || die "waf install failed"
}
