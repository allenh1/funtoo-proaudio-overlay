# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit git-2 python-single-r1 waf-utils

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus"

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README internals.txt )

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mywafconfargs=(
		$(usex dbus "" --disable-dbus)
	)

	NO_WAF_LIBDIR="1"
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
