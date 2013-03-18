# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/a2jmidid/a2jmidid-6.ebuild,v 1.1 2010/01/09 18:49:56 aballier Exp $

EAPI=4
PYTHON_DEPEND="2"

inherit git-2 python toolchain-funcs waf-utils

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
EGIT_REPO_URI="git://repo.or.cz/a2jmidid.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus"

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS README NEWS internals.txt)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	WAF_BINARY="./waf"
	tc-export CC AR CPP LD RANLIB
	local myconf
	myconf="--prefix=${EPREFIX}/usr"
	if use !dbus ; then
		myconf="${myconf} --disable-dbus"
	fi
	# waf fail if I write "${myconf}" 
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" ${WAF_BINARY} configure ${myconf} || die "failed to configure"
}

src_install() {
	waf-utils_src_install
	python_convert_shebangs -r 2 "${ED}"
}
