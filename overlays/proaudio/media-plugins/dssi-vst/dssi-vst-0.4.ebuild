# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit need-gcc-version
IUSE=""
RESTRICT="nomirror"
DESCRIPTION="DSSI wrapper plugin for Windows VSTs"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${PN}_${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
VST_SDK_VER="2.3"

DEPEND=">=media-libs/dssi-0.9.0
	>=x11-libs/gtk+-2
	>=media-libs/liblo-0.12
	dev-util/pkgconfig
	>=app-emulation/wine-0.9.5
	=media-libs/vst-sdk-${VST_SDK_VER}*"

src_unpack() {
	unpack ${A}
	need_gcc "3.4"
	cd $S
	sed -i 's|\"aeffectx.h\"|\<vst/aeffectx.h\>|g' dssi-vst-server.cpp
	sed -i 's|\"aeffectx.h\"|\<vst/aeffectx.h\>|g' dssi-vst-scanner.cpp
}

src_compile(){
	make || die
}

src_install() {
	make BINDIR="${D}/usr/bin" DSSIDIR="${D}/usr/lib/dssi" install || \
	die "install failed"

	dodoc README
}
