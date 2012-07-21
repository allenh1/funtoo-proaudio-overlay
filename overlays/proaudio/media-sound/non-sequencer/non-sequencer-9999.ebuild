# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bristol/bristol-0.60.10.ebuild,v 1.1 2012/06/30 05:54:41 radhermit Exp $

EAPI="4"

inherit git-2

DESCRIPTION="Realtime MIDI sequencer for JACK MIDI"
HOMEPAGE="http://non-mixer.tuxfamily.org"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/sequencer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-debug"
RESTRICT="interactive"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/liblrdf-0.1.0
	>=media-libs/liblo-0.26
	>=dev-libs/libsigc++-2.2.0
	>=x11-libs/fltk-1.1.7:1"
DEPEND="${RDEPEND}"

src_configure() {
	local my_conf=""
	if use debug; then
		my_conf="--enable-debug"
	fi
	econf --prefix=/usr ${my_conf} || die "econf failed"
}

src_compile() {
	make || die "make failed"
}

src_install() {
	einstall DESTDIR=${D} prefix=/usr || die "install failed"
}
