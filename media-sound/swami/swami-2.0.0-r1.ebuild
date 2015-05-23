# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools-utils

DESCRIPTION="A SoundFont instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug fftw fluidsynth nls"

RESTRICT="mirror"

RDEPEND=">=dev-libs/libinstpatch-1.0.0
	>=gnome-base/libgnomecanvas-2.30.3
	>=gnome-base/libglade-2.6.4:2.0
	>=gnome-base/librsvg-2.8:2
	>=media-libs/libsndfile-1.0.0
	>=x11-libs/gtk+-2.20:2
	fftw? ( >=sci-libs/fftw-3.0:3.0 )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# bug?
AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(AUTHORS ChangeLog NEWS README)

PATCHES=(
	# fix crash on execution wrt msg #4249. upstream svn commit rev 387
	"${FILESDIR}/${P}-qsort-args.patch"
)

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--disable-rpath
		--disable-python # upstream recommended until it's fixed
		$(use amd64 && echo --with-pic)
		$(use_enable debug)
		$(use_enable nls)
	)
	autotools-utils_src_configure
}

src_install() {
	# intermittent failures with parallel install jobs, force -j1
	autotools-utils_src_install -j1
}
