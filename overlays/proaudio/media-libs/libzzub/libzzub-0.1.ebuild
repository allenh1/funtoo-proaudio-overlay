# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="buzz compatibility lib for aldrin"
HOMEPAGE="http://trac.zeitherrschaft.org/aldrin"
SRC_URI="mirror://sourceforge/aldrin/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${RDEPEND}
		dev-util/scons"
RDEPEND=">=dev-lang/python-2.4
		>=dev-python/wxpython-2.6
		media-libs/libsndfile
		dev-python/ctypes
		media-libs/ladspa-sdk
		media-sound/jack-audio-connection-kit
		media-libs/alsa-lib
		sys-libs/zlib
		media-libs/flac"

src_compile() {
	scons PREFIX=/usr DESTDIR="${D}" || die "build failed"
}

src_install() {
	scons install || die
	dodoc CREDITS.txt
	cd src/pyzzub
	distutils_src_install
}

