# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GStreamer plugin used by buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mad"

RDEPEND=">=media-libs/gstreamer-0.10.11
	>=media-libs/gst-plugins-base-0.10.0
	>=media-libs/gst-plugins-good-0.10.0
	media-sound/fluidsynth
	mad? ( >=media-plugins/gst-plugins-mad-0.10.0 )"
DEPEND="${RDEPEND}"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
}
