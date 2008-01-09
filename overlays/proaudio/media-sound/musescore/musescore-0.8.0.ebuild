# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils font toolchain-funcs qt4

MY_P=${P/musescore/mscore}

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://mscore.sourceforge.net"
SRC_URI="mirror://sourceforge/mscore/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86 ~amd64"
IUSE="doc jack"

RDEPEND=">=x11-libs/qt-4.3
	media-sound/fluidsynth
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.6
	dev-util/pkgconfig
	doc? ( virtual/tetex app-doc/doxygen )"

S="${WORKDIR}"/${MY_P/.1}
BUILDDIR="${S}"/build
FONT_SUFFIX="otf"
FONT_S="${S}"/mscore/mscore/fonts

pkg_setup() {
	local failure="re-emerge x11-libs/qt with qt3support."

	if ! built_with_use ">=x11-libs/qt-4.3" qt3support; then
		eerror "${failure}"
		die "${failure}"
	fi

	if ! built_with_use ">=x11-libs/qt-4.3" accessibility; then
		eerror "re-emerge x11-libs/qt with accessibility useflag enabled!"
		die
	fi
}

src_compile() {
	if ! use jack; then
		sed -i -e "s/jackaudio.cpp //" ${S}/mscore/mscore/CMakeLists.txt
	fi

	mkdir "${BUILDDIR}"
	cd "${BUILDDIR}"

	cmake \
		-DCMAKE_VERBOSE_MAKEFILE="ON" \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_C_COMPILER="$(type -P $(tc-getCC))" \
		-DCMAKE_CXX_COMPILER="$(type -P $(tc-getCXX))" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_LD_FLAGS="${LDFLAGS}" \
		../mscore || die "cmake failed."

	emake || die "emake failed."
}

src_install() {
	cd "${BUILDDIR}"
	make DESTDIR="${D}" install || die "make install failed."

	font_src_install

	cd "${S}"/mscore
	dodoc ChangeLog NEWS README doc/README.translate
}
