# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2 git-2

DESCRIPTION="Buzz Song Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI=""
EGIT_REPO_URI="git://buzztard.git.sourceforge.net/gitroot/buzztard/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/gnome-vfs:2
	>=media-plugins/gst-buzztard-${PV}
	>=media-sound/buzztard-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	gnome2_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
