# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="SLV2 is a library for LV2 hosts "
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-util/pkgconfig-0.9.0
	media-sound/jack-audio-connection-kit
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.0
	>=sys-libs/raul-9999"

src_unpack() {
	subversion_src_unpack
	cd "${S}/src"
	# quick fix
	esed_check -i 's@:usr/lib/lv2@:/usr/lib/lv2@g' plugins.c
}
src_compile() {
	NOCONFIGURE=1 ./autogen.sh
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
}

