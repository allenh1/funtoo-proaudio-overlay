# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools-utils

DESCRIPTION="Industrializer is a program for generating percussion sounds for musical purposes"
HOMEPAGE="http://sourceforge.net/projects/industrializer"
SRC_URI="mirror://sourceforge/industrializer/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa esd"

RDEPEND=">=x11-libs/gtk+-2.0
		>=x11-libs/gtkglarea-1.99.0
		>=dev-libs/libxml2-2.6
		media-libs/audiofile
		virtual/opengl
		alsa? ( media-libs/alsa-lib )
		esd? ( media-sound/esound )"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9
		sys-devel/gettext"

# bug
AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(AUTHORS ChangeLog README TODO)

PATCHES=("${FILESDIR}/${P}-audiofile-pkgconfig.patch"
	"${FILESDIR}/${P}-missing-m4.patch"
)

src_prepare() {
	autotools-utils_src_prepare
	AT_NOELIBTOOLIZE=yes AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable esd)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodir /usr/share/applications
	mv "${D}"/usr/share/gnome/apps/Multimedia/psindustrializer.desktop \
		"${D}"/usr/share/applications
	rm -rf "${D}"/usr/share/gnome
}
