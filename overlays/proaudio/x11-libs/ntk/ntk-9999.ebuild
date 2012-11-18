# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
inherit waf-utils git-2 python

DESCRIPTION="The Non Things: Non-DAW, Non-Mixer, Non-Sequencer and Non-Session-Manager"
HOMEPAGE="http://non.tuxfamily.org"
#EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/non.git"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/fltk.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-debug"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/liblrdf-0.1.0
	>=media-libs/liblo-0.26
	>=dev-libs/libsigc++-2.2.0"
DEPEND="${RDEPEND}"

pkg_setup(){
	python_set_active_version 2
}

src_configure() {
	myconf=""
	if use debug ; then
		myconf="--enable-debug"
	fi
	waf-utils_src_configure "${myconf}"
}

src_compile() {
	waf-utils_src_compile
}

src_install() {
	waf-utils_src_install
	dodoc CREDITS README
}
