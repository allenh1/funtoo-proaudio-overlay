# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

IUSE="debug mad static"

DESCRIPTION="BEAST - the Bedevilled Sound Engine"
HOMEPAGE="http://beast.gtk.org"
SRC_URI="ftp://beast.gtk.org/pub/beast/v0.7/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86"
SLOT="0"

RDEPEND=">=dev-libs/glib-2.6.4
	>=x11-libs/gtk+-2.6.4
	>=dev-scheme/guile-1.6
	>=x11-libs/pango-1.4.0
	>=media-libs/libart_lgpl-2.3.8
	>=gnome-base/libgnomecanvas-2.4.0
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0
	mad? ( >=media-libs/libmad-0.15.1b )"
DEPEND="dev-util/pkgconfig
	media-libs/ladspa-cmt
	media-libs/ladspa-sdk
	${RDEPEND}"

src_compile() {
	# avoid suid related security issues.
	append-ldflags $(bindnow-flags)

	econf ${myconf} \
		$(use_enable debug) \
		$(use_enable static) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	einfo ""
	einfo "NOTE: If you want to use beast with ALSA, please install"
	einfo "media-plugins/bse-alsa-0.7.1."
	einfo ""
}