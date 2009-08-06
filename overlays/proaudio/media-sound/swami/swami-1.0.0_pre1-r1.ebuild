# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


RESTRICT="mirror"
DESCRIPTION="an instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="audiofile debug nls"

RDEPEND="=x11-libs/gtk+-1.2*
	>=media-sound/fluidsynth-1.0.4
	audiofile? ( >=media-libs/audiofile-0.2.0 )
	>=media-libs/libsndfile-1.0.0
	>=dev-libs/popt-1.5
	>=dev-libs/libinstpatch-1.0.0_pre1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${P/_pre1/}"
src_compile() {
	use amd64 && myconf='--with-pic'
	econf \
		--disable-gtktest --disable-audiofiletest \
		${myconf} \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable audiofile) || die
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
