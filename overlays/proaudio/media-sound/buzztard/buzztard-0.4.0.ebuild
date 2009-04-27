# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 flag-o-matic

DESCRIPTION="free, open source music studio that is conceptionally based on Buzz"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.10
	dev-libs/atk
	x11-libs/pango
	>=gnome-base/libgnomecanvas-2.14.0
	>=media-libs/gstreamer-0.10.11
	>=media-plugins/gst-plugins-alsa-0.10.14
	=media-plugins/gst-buzztard-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	filter-ldflags -Wl,--as-needed --as-needed
	gnome2_src_compile
}

src_install() {
	gnome2_src_install
	# remove some of the mime files to prevent collision, gnome2 eclass
	# takes care of updates in post_inst and post_rm
	rm "${D}/usr/share/mime/generic-icons" "${D}/usr/share/mime/magic" \
		"${D}/usr/share/mime/aliases" "${D}/usr/share/mime/globs2" \
		"${D}/usr/share/mime/globs" "${D}/usr/share/mime/mime.cache" \
		"${D}/usr/share/mime/XMLnamespaces" \
		"${D}/usr/share/mime/subclasses" "${D}/usr/share/mime/icons" \
		"${D}/usr/share/applications/mimeinfo.cache" \
		"${D}/usr/share/mime/types" "${D}/usr/share/mime/treemagic"
}
