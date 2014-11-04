# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

RESTRICT="mirror"
DESCRIPTION="sound font editor library ?"
HOMEPAGE="http://swami.sourceforge.net/"
#SRC_URI="mirror://sourceforge/swami/${P/_/}.tar.gz"

ESVN_REPO_URI="https://swami.svn.sourceforge.net/svnroot/swami/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="3dnow altivec python debug nls sse"

RDEPEND=">=dev-libs/glib-2.0
	>=media-libs/libsndfile-1.0.0
	python? ( dev-lang/python dev-python/pygtk )
	media-libs/audiofile"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	./autogen.sh
	econf \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable altivec) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
