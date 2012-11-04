# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils git-2

DESCRIPTION="The Non Things: Non-DAW, Non-Mixer, Non-Sequencer and Non-Session-Manager"
HOMEPAGE="http://non.tuxfamily.org"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/non.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-debug "

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/liblrdf-0.1.0
	>=media-libs/liblo-0.26
	>=dev-libs/libsigc++-2.2.0
	media-sound/non-session-manager
	"
DEPEND="${RDEPEND}
	x11-libs/ntk
	x11-libs/cairo 
	x11-libs/libXft 
	media-libs/libpng 
	x11-libs/pixman 
	x11-libs/libXpm 
	virtual/jpeg 
	x11-libs/libXinerama
	x11-libs/libxcb 
"

src_configure() {
	if use debug
		then econf --enable-debug=yes
	else 
		econf --enable-debug=no
	fi
}

src_compile() {
#make # builds everything else
	cd ${S}/nonlib 
	make -C nonlib
	cd  ${S}/FL
	make -C  FL
	cd ${S}/mixer 
	make -C  mixer
}

src_install() {
	cd ${S}/mixer
	emake DESTDIR="${D}" install
}

