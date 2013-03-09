# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools-utils
RESTRICT="mirror"
IUSE="jack"
DESCRIPTION="graphical DSSI host, based on jack-dssi-host"
HOMEPAGE="http://www.smbolton.com/linux.html"
SRC_URI="http://www.smbolton.com/linux/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"

RDEPEND=">=media-libs/dssi-0.9.1
	>=media-libs/liblo-0.18
	>=media-libs/ladspa-sdk-1.0
	>=x11-libs/gtk+-2.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.109.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local myeconfargs=( $(use_with jack jackmidi) )
	autotools-utils_src_configure
}
