# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="nomirror"
DESCRIPTION="A GPL sound font editor"
HOMEPAGE="http://swami.sourceforge.net/"
SRC_URI="mirror://sourceforge/swami/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="audiofile debug nls"

DEPEND="media-libs/alsa-lib
	=x11-libs/gtk+-1.2*
	>=media-sound/fluidsynth-1.0.4
	audiofile? ( >=media-libs/audiofile-0.2.0 )
	>=media-libs/libsndfile-1.0.0
	dev-util/pkgconfig
	>=dev-libs/libinstpatch-1.0.0_pre1"

S="${WORKDIR}/${P/_pre1/}"
src_compile() {
	use amd64 && myconf='--with-pic'
	econf ${myconf} \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable audiofile) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}
