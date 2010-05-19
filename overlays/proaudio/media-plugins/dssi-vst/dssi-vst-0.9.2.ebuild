# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib exteutils toolchain-funcs flag-o-matic

DESCRIPTION="DSSI wrapper plugin for Windows VSTs"
HOMEPAGE="http://breakfastquay.com/dssi-vst/"
SRC_URI="http://code.breakfastquay.com/attachments/download/10/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/dssi-0.9.0
	media-libs/ladspa-sdk
	>=media-libs/liblo-0.12
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	>=app-emulation/wine-0.9.5"
DEPEND="${RDEPEND}"

src_unpack() {
	# strip all flags. wineg++ doesn't like it if CXXFLAGS contains things
	# to tune cache sizes like "--param l1-cache-size=32" and it looks like
	# we don't want -fomit-frame-pointer because of instability.
	strip-flags
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.8-Makefile.patch"
	# fixup g++/cxxflags
	esed_check -i -e "s:-Ivestige -Wall -fPIC:${CXXFLAGS} -Ivestige -Wall -fPIC:" \
		-e 's@\([[:blank:]]\)g++\([[:blank:]]\)@\1\$(CXX)\2@g' Makefile
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
