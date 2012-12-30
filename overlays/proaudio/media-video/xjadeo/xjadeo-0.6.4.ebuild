# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator flag-o-matic autotools-utils
MY_P="${PN}-$(replace_version_separator "3" ".")"
DESCRIPTION="xjadeo is a simple video player that is synchronized to jack transport."
HOMEPAGE="http://xjadeo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="xv sdl osd qt4 tools lash tiff"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-video/ffmpeg-0.4.9
	>=media-libs/alsa-lib-1.0.10
	>=media-libs/imlib2-1.3.0
	lash? ( virtual/liblash )
	sdl? ( >=media-libs/libsdl-1.2.8 )"

DEPEND="${RDPEND}
	>=sys-libs/zlib-1.2.2
	qt4? ( || ( x11-libs/qt-qt3support
		>=x11-libs/qt-4:4[qt3support] )
		>=x11-libs/qt-test-4:4
	)
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD="1"

DOCS=( AUTHORS ChangeLog TODO README NEWS )

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myeconfargs=(	$(use_enable xv) \
						$(use_enable sdl) \
						$(use_enable osd ft) \
						$(use_enable tools contrib) \
						$(use_enable lash) \
						$(use_enable tiff) \
						$(use_enable qt4 qtgui) \
						--enable-imlib2 \
						--without-portmidisrc \
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use tools && newdoc contrib/README README-tools
	insinto /usr/share/${PN}
	use tools && doins contrib/xjadeo-example.avi
}
