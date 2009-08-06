# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="soma is a complete audio broadcasting solution"
HOMEPAGE="http://www.somasuite.org"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="pic ssl"

DEPEND=">=media-libs/freetype-2.0.9
		>=media-libs/libsdl-0.11.0
		>=dev-util/pkgconfig-0.9
		ssl? ( dev-libs/openssl )"

src_compile() {
	econf \
		`use_with pic` \
		`use_enable openssl` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS README.module NEWS
}

