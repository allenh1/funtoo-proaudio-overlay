# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

RESTRICT="nomirror"
IUSE="boost osc lash jack debug"
DESCRIPTION="Realtime Audio Utility Library: lightweight header-only C++"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""

DEPEND=">=dev-util/pkgconfig-0.9.0
	osc? ( >=media-libs/liblo-0.22 )
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.14
	boost? ( dev-libs/boost )
	media-libs/librdf
	>=dev-cpp/glibmm-2.4
	jack? ( >=media-sound/jack-audio-connection-kit-0.107.0 )
	lash? ( >=media-sound/lash-0.5.2 
		>=dev-libs/libsigc++-2 )"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	cd "${S}/${PN}" || die "source for ${PN} not found"
	NOCONFIGURE=1 ./autogen.sh
	econf \
		$(use_enable boost smart_pointers) \
		--enable-raptor \
		$(use_enable debug) \
		$(use_enable osc liblo) \
		$(use_enable lash) \
		$(use_enable jack) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
} 
