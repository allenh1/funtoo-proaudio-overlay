# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit jackmidi eutils
RESTRICT="mirror"
IUSE="jackmidi"
DESCRIPTION="graphical DSSI host, based on jack-dssi-host"
HOMEPAGE="http://www.smbolton.com/linux.html"
SRC_URI="http://www.smbolton.com/linux/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND=">=media-libs/dssi-0.9.1
	>=x11-libs/gtk+-2.0
	dev-util/pkgconfig
	>=media-libs/liblo-0.18
	>=media-libs/ladspa-sdk-1.0
	jackmidi? ( >=media-sound/jack-audio-connection-kit-0.109.0 )
	>=media-libs/ladspa-sdk-1.0"

src_unpack() {
	use jackmidi && need_jackmidi
	unpack ${A}
	cd "$S"
}

src_compile() {
	#./autogen.sh
	#autoconf
	#libtoolize --copy --force
	econf `use_with jackmidi` --with-gtk2|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog README NEWS
}
