# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AT_M4DIR="m4"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Industrializer is a program for generating percussion sounds for musical purposes"
HOMEPAGE="http://sourceforge.net/projects/industrializer"
SRC_URI="mirror://sourceforge/industrializer/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

RDEPEND=">=dev-libs/libxml2-2.6
	media-libs/audiofile
	>=x11-libs/gtk+-2.0
	>=x11-libs/gtkglarea-1.99.0
	virtual/opengl
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(AUTHORS ChangeLog README TODO)

PATCHES=("${FILESDIR}/${P}-audiofile-pkgconfig.patch"
	"${FILESDIR}/${P}-missing-m4.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable alsa)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodir /usr/share/applications
	mv "${ED}"/usr/share/gnome/apps/Multimedia/psindustrializer.desktop \
		"${ED}"/usr/share/applications
	rm -rf "${ED}"/usr/share/gnome
}
