# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets

DESCRIPTION="Live looping sampler with immediate loop recording"
HOMEPAGE="http://essej.net/sooperlooper/index.html"
SRC_URI="http://essej.net/sooperlooper/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.80
	=x11-libs/wxGTK-2.6*
	>=media-libs/liblo-0.18
	=dev-libs/libsigc++-1.2*
	media-libs/libsndfile
	media-libs/libsamplerate
	sys-libs/ncurses
	dev-libs/libxml2
	media-libs/rubberband"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
}

src_compile() {
	WX_GTK_VER="2.6"
	econf --disable-optimize --with-wxconfig-path="${WX_CONFIG}"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc OSC README
}
