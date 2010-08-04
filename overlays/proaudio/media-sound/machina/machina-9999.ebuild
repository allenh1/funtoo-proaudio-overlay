# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs multilib

RESTRICT="mirror"
IUSE="debug"

DESCRIPTION="A polyphonic MIDI sequencer based on probabilistic finite-state automata"
HOMEPAGE="http://drobilla.net/software/machina/"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND="=dev-libs/redlandmm-9999
	=media-libs/raul-9999
	=x11-libs/flowcanvas-9999
	>=media-sound/jack-audio-connection-kit-0.109.0"

src_compile() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	./waf configure --prefix=/usr \
		--libdir=/usr/$(get_libdir)/ \
		$(use debug && echo "--debug") || die "waf configure failed"

	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	cd ${PN}
	./waf install --destdir="${D}" || die "waf install failed"
	dodoc AUTHORS README THANKS
}
