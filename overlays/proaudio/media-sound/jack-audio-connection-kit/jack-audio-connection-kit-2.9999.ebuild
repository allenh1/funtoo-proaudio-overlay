# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 waf-utils

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa classic doc debug freebob dbus ieee1394 mixed pam"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-1.0.24
	pam? ( sys-auth/realtime-base )"
DEPEND="${RDEPEND}
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )
	media-libs/libsamplerate"

src_unpack() {
	git-2_src_unpack
}

pkg_setup() {
	# sandbox-1.6 breaks, on amd64 at least

	# paludis...
	if has_version "=sys-apps/sandbox-1.6" && [[ -n $(echo `ps -fp $$`|grep paludis) ]]; then
		eerror "The compile will hang with =sandbox-1.6. You are using paludis,"
		eerror "so you'll have to downgrade sandbox."
		die
	fi

	# portage
	if use amd64 && has "sandbox" ${FEATURES} && ! has "-sandbox" ${FEATURES} && has_version "=sys-apps/sandbox-1.6"; then
		eerror "The compile will hang with =sandbox-1.6. Please use:"
		echo
		eerror "FEATURES=\"-sandbox\" emerge ${PN}"
		echo
		eerror "OR downgrade sandbox to 1.4 at least."
		die
	fi
}

src_prepare()
{
	epatch "${FILESDIR}"/jack-audio-connection-kit-2.9999-link-fix.patch
}

src_configure() {
	local myconf="--prefix=/usr --destdir=${D}"
	use alsa && myconf="${myconf} --alsa"
	if use classic && use dbus ; then
		myconf="${myconf} --classic"
	fi
	if use mixed && use amd64 ; then
		myconf="${myconf} --mixed"
	fi
	use dbus && myconf="${myconf} --dbus"
	use debug && myconf="${myconf} --debug"
	use doc && myconf="${myconf} --doxygen"
	use freebob && myconf="${myconf} --freebob"
	use ieee1394 && myconf="${myconf} --firewire"

	einfo "Running \"./waf configure ${myconf}\" ..."
	waf-utils_src_configure  ${myconf}
}

src_compile()
{
	waf-utils_src_compile
}
