# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fdo-mime gnome2-utils

EAPI="1"

DESCRIPTION="Buzz Song Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="dev-libs/glib:2
	gnome-base/gnome-vfs:2
	=media-plugins/gst-buzztard-${PV}
	=media-sound/buzztard-${PV}"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		`use_enable debug ` \
		--with-desktop-dir="${D}/usr/share" \
		|| die "Configure failed"
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	
	# hack that desktop file crap
	mv "${D}/${D}/usr/share/applications" "${D}/usr/share/" || die
	rm -f ${D}/usr/share/applications/mimeinfo.cache || die
	rm -r ${D}/${D} || die
	# holy f*ck...
	find ${D}/usr/share/mime/ -type f -maxdepth 1 -delete || die
	
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

