# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

RESTRICT="nomirror"
IUSE="boost osc"
DESCRIPTION="Realtime Audio Utility Library: lightweight header-only C++"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/${PN}"


LICENSE="GPL-2"
KEYWORDS="-*"

DEPEND=">=dev-util/pkgconfig-0.9.0
	osc? ( >=media-libs/liblo-0.22 )
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.0
	boost? ( dev-libs/boost )"

src_compile() {
	NOCONFIGURE=1 ./autogen.sh
	econf \
		$(use_enable boost smart_pointers) \
		--enable-raptor \
		$(use_enable osc liblo) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
} 
