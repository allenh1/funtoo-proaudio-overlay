# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/swami/swami-0.9.4.ebuild,v 1.3 2007/08/23 17:43:44 drac Exp $

DESCRIPTION="an instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="audiofile debug nls"

RDEPEND="=x11-libs/gtk+-1.2*
	>=media-sound/fluidsynth-1.0.4
	audiofile? ( >=media-libs/audiofile-0.2.0 )
	>=media-libs/libsndfile-1.0.0
	>=dev-libs/popt-1.5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		--disable-gtktest --disable-audiofiletest \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable audiofile) || die
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
