# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Constructs an approximation of one sound out of small pieces of other sounds"
HOMEPAGE="http://awesame.org/soundmosaic/"
SRC_URI="http://awesame.org/${PN}/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=media-libs/audiofile-0.2.6-r4
		>=x11-libs/libX11-1.1.5"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README TODO
}
