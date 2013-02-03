# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
inherit scons-utils eutils toolchain-funcs flag-o-matic multilib python

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
	qt4? ( dev-python/PyQt4
		   >=dev-python/dbus-python-0.83.0 )"
DEPEND="${RDEPEND}
	dev-util/scons
	virtual/pkgconfig"

RESTRICT="mirror"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch
	python_convert_shebangs -r 2 .
}

src_configure() {
	myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		$(use_scons debug DEBUG)
		$(use_scons test-programs BUILD_TESTS)
		# ENABLE_OPTIMIZATIONS detects cpu type and sets flags accordingly
		# -fomit-frame-pointer is added also which can cripple debugging.
		# we set flags from portage instead
		ENABLE_OPTIMIZATIONS=False
	)
}

src_compile () {
	# workaround because jackd --version is called that tries to use
	# /dev/snd/control*
	addpredict /dev/snd

	tc-export CC CXX
	escons
}

src_install () {
	escons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install
	dodoc AUTHORS ChangeLog README

	if use qt4; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}

pkg_postinst() {
	python_mod_optimize ffado
	python_mod_optimize "${EPREFIX}/usr/share/${PN}/python"
}

pkg_postrm() {
	python_mod_cleanup ffado
	python_mod_cleanup "${EPREFIX}/usr/share/${PN}/python"
}
