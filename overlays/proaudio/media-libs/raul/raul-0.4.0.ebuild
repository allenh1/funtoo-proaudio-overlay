# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


RESTRICT="mirror"
IUSE="boost osc lash jack debug"
DESCRIPTION="Realtime Audio Utility Library: lightweight header-only C++"
HOMEPAGE="http://wiki.drobilla.net/Raul"
SRC_URI="http://download.drobilla.net/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND=">=dev-util/pkgconfig-0.9.0
	osc? ( >=media-libs/liblo-0.22 )
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.14
	boost? ( dev-libs/boost )
	dev-libs/redland
	>=dev-cpp/glibmm-2.4
	jack? ( >=media-sound/jack-audio-connection-kit-0.107.0 )
	lash? ( >=media-sound/lash-0.5.2
		>=dev-libs/libsigc++-2 )
	=dev-libs/redlandmm-9999"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	#cd "${S}/${PN}" || die "source for ${PN} not found"
	#NOCONFIGURE=1 ./autogen.sh
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
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog README
}
