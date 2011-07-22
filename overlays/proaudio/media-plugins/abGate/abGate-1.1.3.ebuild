# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="LV2 Noise Gate plugin"
HOMEPAGE="http://abgate.sourceforge.net/"
SRC_URI="mirror://sourceforge/abgate/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 x86"
SLOT="0"
IUSE=""

DEPEND="dev-cpp/gtkmm:2.4
	media-libs/lv2core"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}|| die "Unpacking failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README ChangeLog
}
