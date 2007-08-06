# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="alsa gnome lash nls xml"

inherit eutils

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="mirror://sourceforge/jack-rack/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="=x11-libs/gtk+-2*
	>=media-libs/ladspa-sdk-1.12
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	lash? ( >=media-sound/lash-0.5.0 )
	gnome? ( =gnome-base/libgnomeui-2* )
	nls? ( virtual/libintl )
	xml? ( dev-libs/libxml2
		media-libs/liblrdf )"

MAKEOPTS="-j1"

src_compile() {
	local myconf
	myconf="--disable-ladcca --enable-desktop-inst"

	econf \
		${myconf} \
		$(use_enable alsa aseq) \
		$(use_enable gnome) \
		$(use_enable lash) \
		$(use_enable nls) \
		$(use_enable xml) \
		$(use_enable xml lrdf) \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST
}
