# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit exteutils multilib git-2 scons-utils

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://abraca.github.com/Abraca"

EGIT_REPO_URI="https://github.com/Abraca/Abraca.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc debug"
KEYWORDS=""
RDEPEND=">=media-sound/xmms2-0.8
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.0.0
	>=dev-libs/libgee-0.6
	dev-lang/vala:0.18"
DEPEND="${RDEPEND}
	dev-util/scons"

pkg_setup() {
	export VALAC="$(type -P valac-0.18)"
}

src_compile() {
	escons \
		$(scons_use_enable debug) \
		PREFIX=/usr \
		LIDBDIR="/usr/$(get_libdir)" \
		|| die "scons failed"
}

src_install() {
	escons DESTDIR="${D}" install || die
	dodoc AUTHORS README
}
