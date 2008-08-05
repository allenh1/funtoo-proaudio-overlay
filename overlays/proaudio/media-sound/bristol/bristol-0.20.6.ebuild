# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"

inherit eutils toolchain-funcs autotools

DESCRIPTION="synthesiser emulation package for Moog, Sequential Circuits, Hammond and several other keyboards."
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa jack static"

RDEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
				virtual/x11 )
		>=media-libs/alsa-lib-1.0.0
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	dev-util/pkgconfig"

src_compile() {
	econf \
		`use_enable alsa` \
		`use_enable jack` \
		`use_enable static` \
		${myconf} \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog AUTHORS README NEWS
}

pkg_postinst() {
	echo
	elog "To use Bristol with jack, use something like:"
	echo
	elog "startBristol -audio jack"
	echo
}
