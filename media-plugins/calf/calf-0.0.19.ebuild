# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [[ "${PV}" = "9999" ]] ; then
	inherit git-r3
	AUTOTOOLS_AUTORECONF=yes
fi
inherit autotools-utils

DESCRIPTION="A set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf.sourceforge.net/"
RESTRICT="mirror"

if [[ "${PV}" = "9999" ]] ; then
	EGIT_REPO_URI="git://repo.or.cz/calf.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="lash lv2 static-libs"

RDEPEND="dev-libs/expat
	dev-libs/glib:2
	gnome-base/libglade:2.0
	media-sound/fluidsynth
	media-sound/jack-audio-connection-kit
	x11-libs/gtk+:2
	lash? ( virtual/liblash )
	lv2? ( media-libs/lv2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myeconfargs=(
		--with-lv2-dir=/usr/$(get_libdir)/lv2
		$(use_with lash)
		$(use_with lv2)
	)
	autotools-utils_src_configure
}
