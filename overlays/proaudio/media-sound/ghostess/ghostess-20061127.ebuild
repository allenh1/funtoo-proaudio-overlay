# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit jackmidi
RESTRICT="nomirror"
IUSE="jackmidi"
DESCRIPTION="graphical DSSI host, based on jack-dssi-host"
HOMEPAGE="http://home.jps.net/~musound/"
SRC_URI="http://home.jps.net/~musound/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND=">=media-libs/dssi-0.9.1
	>=x11-libs/gtk+-2.0
	dev-util/pkgconfig
	>=media-libs/liblo-0.18
	>=media-libs/ladspa-sdk-1.0
	jackmidi? ( media-sound/jack-audio-connection-kit )
	>=media-libs/ladspa-sdk-1.0"

src_unpack() {
	use jackmidi && need_jackmidi
	unpack ${P}.tar.gz
}

src_compile() {
	#./autogen.sh
	#autoconf
	#libtoolize --copy --force
	econf `use_with jackmidi` --with-gtk2|| die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS
}
