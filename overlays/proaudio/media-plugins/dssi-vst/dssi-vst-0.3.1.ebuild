# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fluidsynth-dssi/fluidsynth-dssi-0.9.1.ebuild,v 1.1 2005/10/09 01:15:09 matsuu Exp $

IUSE=""
RESTRICT="nomirror"
DESCRIPTION="DSSI wrapper plugin for Windows VSTs"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
VST_SDK_VER="2.3"

DEPEND=">=media-libs/dssi-0.9.0
	>=x11-libs/gtk+-2
	>=media-libs/liblo-0.12
	dev-util/pkgconfig
	=app-emulation/wine-20041019-r3
	=media-libs/vst-sdk-${VST_SDK_VER}*"

src_unpack() {
	unpack ${P}.tar.gz
	cd $S
	sed -i 's|\"aeffectx.h\"|\<vst/aeffectx.h\>|g' dssi-vst-server.cpp
	sed -i 's|\"aeffectx.h\"|\<vst/aeffectx.h\>|g' dssi-vst-scanner.cpp
}

src_compile(){
	TARGET_DSSI_DIR=/usr/lib/dssi
	INCLUDE_PATH=/usr/include/vst
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc ChangeLog README TODO
}
