# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit base scons-utils eutils toolchain-funcs multilib python-single-r1 udev

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
SRC_URI="http://www.ffado.org/files/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="debug qt4 +test-programs"

RDEPEND=">=dev-cpp/libxmlpp-2.6.13
	>=dev-libs/dbus-c++-0.9.0
	>=dev-libs/libconfig-1.4.8
	>=media-libs/alsa-lib-1.0.0
	>=media-libs/libiec61883-1.1.0
	>=sys-apps/dbus-1.0
	>=sys-libs/libraw1394-2.0.7
	>=sys-libs/libavc1394-0.5.3
	qt4? (
		dev-python/PyQt4[${PYTHON_USEDEP}]
		>=dev-python/dbus-python-0.83.0[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=( AUTHORS ChangeLog README )

#PATCHES=(
#	"${FILESDIR}/${P}"
#	"${FILESDIR}/${P}-no-jackd-version.patch"
#)
#EPATCH_SUFFIX="patch"

src_prepare() {
	base_src_prepare
	python_fix_shebang "${S}"
}

src_configure() {
	myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		UDEVDIR="$(get_udevdir)/rules.d"
		$(use_scons debug DEBUG)
		$(use_scons test-programs BUILD_TESTS)
		# ENABLE_OPTIMIZATIONS detects cpu type and sets flags accordingly
		# -fomit-frame-pointer is added also which can cripple debugging.
		# we set flags from portage instead
		ENABLE_OPTIMIZATIONS=False
	)
}

src_compile () {
	tc-export CC CXX
	escons
}

src_install () {
	escons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install

	base_src_install_docs

	python_optimize "${D}"

	if use qt4; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}
