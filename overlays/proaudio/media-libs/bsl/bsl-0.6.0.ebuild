# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2

DESCRIPTION="Buzz Song Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/gnome-vfs:2
	>=media-plugins/gst-buzztard-${PV}
	>=media-sound/buzztard-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

src_install() {
	gnome2_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO

	# remove some of the mime files to prevent collision, gnome2 eclass
	# takes care of updates in post_inst and post_rm
	cd "${ED}"/usr/share/mime/
	rm -rf XMLnamespaces aliases generic-icons globs globs2 icons magic \
		mime.cache subclasses treemagic types version
}
