# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/a2jmidid/a2jmidid-6.ebuild,v 1.1 2010/01/09 18:49:56 aballier Exp $

EAPI=2

PYTHON_DEPEND="2:2.7"
inherit git python toolchain-funcs

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
EGIT_REPO_URI="git://repo.or.cz/a2jmidid.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	tc-export CC AR CPP LD RANLIB
	./waf configure --prefix=/usr || die "failed to configure"
	./waf || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS internals.txt
}
