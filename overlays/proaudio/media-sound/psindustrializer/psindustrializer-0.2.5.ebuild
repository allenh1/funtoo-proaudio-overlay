# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Industrializer is a program for generating percussion sounds for musical purposes"
HOMEPAGE="http://sourceforge.net/projects/industrializer"
SRC_URI="mirror://sourceforge/industrializer/${P}.tar.bz2"

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa esd"

RDEPEND=">=x11-libs/gtk+-2.0
		>=x11-libs/gtkglarea-1.99.0
		>=dev-libs/libxml2-2.6
		media-libs/audiofile
		virtual/opengl
		alsa? ( virtual/alsa )
		esd? ( media-sound/esound )"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9
		sys-devel/gettext"

src_compile() {
	econf \
		$(use_enable alsa) \
		$(use_enable esd) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodir /usr/share/applications
	mv "${D}"/usr/share/gnome/apps/Multimedia/psindustrializer.desktop \
		"${D}"/usr/share/applications
	rm -rf "${D}"/usr/share/gnome
	dodoc README CHANGES
}

