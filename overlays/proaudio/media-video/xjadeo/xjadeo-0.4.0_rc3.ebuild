# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator
MY_P="${PN}-$(replace_version_separator "3" ".")"
DESCRIPTION="xjadeo is a simple video player that is synchronized to jack transport."
HOMEPAGE="http://xjadeo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="gpl"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="xv sdl osd qt3 qt4 tools lash tiff"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100
	>=media-video/ffmpeg-0.4.9
	>=media-libs/alsa-lib-1.0.10
	>=media-libs/imlib2-1.3.0
	lash? ( >=media-sound/lash-0.4.0 )
	sdl? ( >=media-libs/libsdl-1.2.8 )"

DEPEND="${RDPEND}
	>=sys-libs/zlib-1.2.2
	qt3? ( >=x11-libs/qt-3 )
	qt4? ( >=x11-libs/qt-4.1 )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	if use qt4 ;then
		export QTDIR=/usr
		export QLIBS=/usr/lib/qt4
		myconf="--enable-qtgui"
	fi
		
		econf $(use_enable xv) \
		$(use_enable sdl) \
		$(use_enable osd ft) \
		$(use_enable qt3 qtgui) \
		$(use_enable tools contrib) \
		$(use_enable lash) \
		$(use_enable tiff) \
		$myconf --disable-imlib --enable-imlib2 || die "econf failed"
	emake || die
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog TODO README NEWS
	use tools && newdoc contrib/README README-tools
	insinto /usr/share/${PN}
	use tools && doins contrib/xjadeo-example.avi
}
