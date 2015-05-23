# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="python? 2:2.4"

inherit eutils python

RESTRICT="mirror"
DESCRIPTION="SoundFont editor library from the Swami project"
HOMEPAGE="http://swami.sourceforge.net/"
SRC_URI="mirror://sourceforge/swami/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug nls python"

RDEPEND=">=media-libs/libsndfile-1.0.0
	>=dev-libs/glib-2.0
	python? ( dev-python/pygtk )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --disable-dependency-tracking \
		--disable-rpath \
		--with-pic \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable python) || die "econf failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
