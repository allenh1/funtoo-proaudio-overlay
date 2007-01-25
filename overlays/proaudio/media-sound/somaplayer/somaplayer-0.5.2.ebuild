# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="soma is a complete audio broadcasting solution"
HOMEPAGE="http://www.somasuite.org"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk mp3 nls ogg pic ssl"

DEPEND=">=dev-util/pkgconfig-0.9
		sys-devel/bison
		media-sound/soma
		dev-libs/libxml2
		gtk? ( =x11-libs/gtk+-2* )
		mp3? ( media-libs/libmad )
		ogg? ( media-libs/libogg )"
RDEPEND="virtual/libiconv"

src_compile() {
	econf \
		`use_with pic` \
		`use_enable nls` \
		`use_enable mp3 mad` \
		`use_enable ogg` \
		`use_enable gtk` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS README.module NEWS
}

