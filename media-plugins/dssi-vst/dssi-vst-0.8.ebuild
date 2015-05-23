# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib exteutils toolchain-funcs

DESCRIPTION="DSSI wrapper plugin for Windows VSTs"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=media-libs/dssi-0.9.0
	media-libs/ladspa-sdk
	>=media-libs/liblo-0.12
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	>=app-emulation/wine-0.9.5"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-Makefile.patch"
	# fixup g++/cxxflags
	esed_check -i -e "s:-Ivestige -Wall -fPIC:${CXXFLAGS} -Ivestige -Wall -fPIC:" \
		-e 's@\([[:blank:]]\)g++\([[:blank:]]\)@\1\$(CXX)\2@g' Makefile
	# fixup includes for gcc 4.3 compat
	esed_check -i "-e/#/{;s/#/#include <stdio.h>\n#/;:a" "-en;ba" "-e}" \
		remotepluginclient.cpp dssi-vst.cpp rdwrops.cpp remotevstclient.cpp \
		remotepluginserver.cpp
}

src_compile(){
	tc-export CXX
	emake || "die emake failed"
}

src_install() {
	make \
		BINDIR="${D}/usr/bin" \
		DSSIDIR="${D}/usr/$(get_libdir)/dssi" \
		LADSPADIR="${D}/usr/$(get_libdir)/ladspa" install \
		|| die "install failed"
	dodoc README
}
