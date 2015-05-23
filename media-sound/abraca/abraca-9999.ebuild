# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit exteutils multilib git-2 waf-utils

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://abraca.github.com/Abraca"

EGIT_REPO_URI="https://github.com/Abraca/Abraca.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""
RDEPEND=">=media-sound/xmms2-0.8
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.0.0
	dev-libs/libgee:0
	dev-lang/vala:0.18"
DEPEND="${RDEPEND}"

pkg_setup() {
	export VALAC="$(type -P valac-0.18)"
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	waf-utils_src_configure || die "waf configure failed"
}

src_compile() {
	waf-utils_src_compile || die "waf build failed"
}

src_install() {
	waf-utils_src_install || die "waf install failed"
#	dodoc AUTHORS README.markdown
}
