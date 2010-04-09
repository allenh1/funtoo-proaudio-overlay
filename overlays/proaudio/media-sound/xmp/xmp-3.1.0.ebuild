# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="X alsa audacious esd nas oss pulseaudio"

inherit eutils

DESCRIPTION="Extended Module Player"
HOMEPAGE="http://xmp.sf.net"
SRC_URI="mirror://sourceforge/xmp/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
RESTRICT="mirror"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )
	alsa? ( >=media-libs/alsa-lib-1.0.14a-r1 )
	audacious? ( >=media-sound/audacious-2.2 )
	esd? ( >=media-sound/esound-0.2.38-r1 )
	nas? ( >=media-libs/nas-1.8b )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )"

src_compile() {
	econf \
		$(use_enable alsa) \
		--disable-arts \
		$(use_enable audacious audacious-plugin) \
		$(use_enable esd) \
		$(use_enable nas) \
		$(use_enable oss) \
		$(use_enable pulseaudio) \
		$(use_with X x) \
		|| die "configure failed"

	# parallel make appears to be broken =(
	make -j1 || die "make failed"
}

src_install () {
	# do not strip!
	sed -i -e 's/$(INSTALL) -s/$(INSTALL) /' "${S}/src/main/Makefile" \
		|| die "sed of src/main/Makefile failed"
	sed -i -e 's/$(INSTALL) -s/$(INSTALL) /g' "${S}/src/plugin/Makefile" \
		|| die "sed of src/plugin/Makefile failed"

	make DESTDIR="${D}" install || die "install failed"
	dodoc README
	# we should really include something to test with, but not included due
	# to doubts regarding license of this mod
	#insinto /usr/share/doc/${PF}
	#doins anticipation.mod
}
