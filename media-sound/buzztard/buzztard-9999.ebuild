# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2 eutils autotools git-2

DESCRIPTION="A free, open source music studio that is conceptionally based on Buzz"
HOMEPAGE="http://www.buzztard.org"
SRC_URI=""
EGIT_REPO_URI="git://buzztard.git.sourceforge.net/gitroot/buzztard/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +introspection static-libs"

RDEPEND=">=gnome-base/libgnomecanvas-2.14.0
	>=media-libs/gstreamer-0.10.11:0.10[introspection?]
	>=media-plugins/gst-plugins-alsa-0.10.14:0.10
	>=media-plugins/gst-buzztard-${PV}
	>=x11-libs/gtk+-2.10:2[introspection?]
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	!media-libs/bsl
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch
	AT_NOELIBTOOLIZE=yes eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-dependency-tracking \
		$(use_enable doc gtk-doc-html) \
		$(use_enable introspection) \
		$(use_enable static-libs static)
}

src_install() {
	gnome2_src_install
	# remove some of the mime files to prevent collision, gnome2 eclass
	# takes care of updates in post_inst and post_rm
	cd "${ED}"/usr/share/mime/
	rm -rf XMLnamespaces aliases generic-icons globs globs2 icons magic \
		mime.cache subclasses treemagic types version
}
