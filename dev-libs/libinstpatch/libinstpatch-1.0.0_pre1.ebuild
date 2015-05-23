# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/dev-libs/libinstpatch/libinstpatch-1.0.0_pre1.ebuild,v 1.1 2006/04/10 12:18:30 gimpel Exp $

inherit eutils

RESTRICT="mirror"
DESCRIPTION="sound font editor library ?"
HOMEPAGE="http://swami.sourceforge.net/"
SRC_URI="mirror://sourceforge/swami/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~ppc"
IUSE="python debug nls"

DEPEND=">=dev-libs/glib-2.0
	>=media-libs/libsndfile-1.0.0
	python? ( dev-lang/python )
	virtual/pkgconfig"

RDEPEND=">=dev-libs/glib-2.0
	>=media-libs/libsndfile-1.0.0
	python? ( dev-lang/python )"

S="${WORKDIR}/${P/_pre1/}"
src_compile() {
	./autogen.sh
	econf \
		$(use_enable nls) \
		$(use_enable debug) || die "econf failed"
		#$(use_enable audiofile) || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}
