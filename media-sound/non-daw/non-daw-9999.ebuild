# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
inherit waf-utils git-2 python

DESCRIPTION="The Non Things: Non-DAW, Non-Mixer, Non-Sequencer and Non-Session-Manager"
HOMEPAGE="http://non.tuxfamily.org"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/non.git"
#EGIT_BRANCH="waf"
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
	>=x11-libs/ntk-1.3.0
	x11-libs/cairo
	x11-libs/libXft
	media-libs/libpng
	x11-libs/pixman
	>=x11-libs/libXpm-2.0.0
	virtual/jpeg
	x11-libs/libXinerama
	x11-libs/libxcb
"
pkg_setup(){
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
#	${WAF_BINARY:="${S}/waf"}
	if use debug
		then waf-utils_src_configure --project=timeline --enable-debug
		else waf-utils_src_configure --project=timeline
	fi
}

src_compile() {
	waf-utils_src_compile
}

src_install() {
	waf-utils_src_install
	dobin "${S}/timeline/bin/import-external-sources"
	dobin "${S}/timeline/bin/remove-unused-sources"
}
