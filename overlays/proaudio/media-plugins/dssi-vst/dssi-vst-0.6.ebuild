# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib exteutils

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
	>=app-emulation/wine-0.9.5"

src_unpack() {
	unpack ${A}
	cd ${S}
	# link fix
	esed_check -i -e 's/\(LDFLAGS\)\(\ *\)\([^I]*\)\(=\)/\1 = -lpthread/' Makefile
	if use amd64;then
		# remove target all: from install: This is done because the targets
		# for amd64 are built in two steps: First 64-Bit and the vst part 32-Bit
		# and we still want to use the install function provided by dssi-vst
		esed_check -i -e 's@install:\tall@install:@g' Makefile
		esed_check -i -e 's/\(CXXFLAGS\)\(\ *\)\([^I]*\)\(=\)/\1 = -fPIC/' Makefile
	fi
}

src_compile(){
	if use amd64;then
		# 64-Bit-part
		emake dssi-vst.so dssi-vst_gui vsthost || die "emake *.so vst_gui vsthost failed"
		mkdir amd64
		mv dssi-vst.so dssi-vst_gui vsthost amd64/ || die "moving for amd64 failed"

		# 32 bit-part
		emake clean || die "emake clean failed"
		# compile the 32Bit part
		multilib_toolchain_setup x86
		emake dssi-vst-server.exe.so dssi-vst-scanner.exe.so || die "32Bit part failed"
		mv amd64/* .
	else
		emake || "die emake failed"
	fi
}

src_install() {
	make BINDIR="${D}/usr/bin" DSSIDIR="${D}/usr/lib/dssi" install || \
	die "install failed"
	dodoc README
}

