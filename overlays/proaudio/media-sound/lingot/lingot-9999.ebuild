# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils mercurial

DESCRIPTION="LINGOT Is Not a Guitar-Only Tuner"
HOMEPAGE="http://www.nongnu.org/lingot"
EHG_REPO_URI="http://hg.sv.gnu.org/hgweb/lingot"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa +fftw jack"

PATCHES=( "${FILESDIR}"/${P}-clean-install.patch )

RDEPEND="x11-libs/gtk+:3
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	dev-libs/glib:2
	gnome-base/libglade:2.0
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0 )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_configure() {
	local myeconfargs=(
		--disable-oss
		--disable-pulseaudio
		$(use_enable alsa)
		$(use_enable jack)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install lingotdocdir="/usr/share/doc/${PF}"
}
