# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets

DESCRIPTION="Wired aims to be a professional music production and creation software running on the Linux operating system."
HOMEPAGE="http://wired.epitech.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="dssi nls pic static"

DEPEND="media-libs/alsa-lib
	media-libs/libsndfile
	>=x11-libs/gtk+-2.0.0
	>=x11-libs/wxGTK-2.6.2
	>=media-libs/portaudio-19
	>=media-libs/libsoundtouch-1.2.1
	dssi? ( media-libs/dssi )"

src_compile() {
	WX_GTK_VER=2.6
	if need-wxwidgets gtk2 && wx-config-2.6 --version | grep 2.6
	then
		econf \
		$(use_with pic) \
		$(use_enable static) \
		$(use_enable dssi) \
		$(use_enable nls) || die "configure failed"

		emake || die "make failed"
	else
		die "You need to emerge >=x11-libs/wxGTK-2.6.2 with USE=\"gtk2\""
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README
}

