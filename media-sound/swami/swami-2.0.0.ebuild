# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="python? 2:2.4"

inherit autotools python

RESTRICT="mirror"
DESCRIPTION="A SoundFont instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug nls python"

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=media-sound/fluidsynth-1.0.4
	>=media-libs/libsndfile-1.0.0
	>=dev-libs/libinstpatch-1.0.0[python?]
	python? ( dev-python/pygtk )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# this works around an intermittent build failure where the libswamigui.so
	# file is truncated
	eautoreconf
}

src_configure() {
	econf --disable-dependency-tracking \
		--disable-rpath \
		--with-pic \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable python) || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
