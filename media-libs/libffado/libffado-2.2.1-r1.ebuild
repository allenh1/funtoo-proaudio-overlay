# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
[[ "${PV}" = "9999" ]] && inherit subversion
inherit base eutils multilib python-single-r1 scons-utils toolchain-funcs udev

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"

RESTRICT="mirror"
if [ "${PV}" = "9999" ]; then
	ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.ffado.org/files/${P}.tgz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug qt4 +test-programs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-cpp/libxmlpp
	dev-libs/dbus-c++
	dev-libs/libconfig[cxx]
	media-libs/alsa-lib
	media-libs/libiec61883
	media-sound/jack-audio-connection-kit
	sys-apps/dbus
	sys-libs/libraw1394
	sys-libs/libavc1394
	${PYTHON_DEPS}
	qt4? (
		dev-python/PyQt4[dbus,${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-jack-detect.patch
	"${FILESDIR}"/${P}-detect-userspace-env.patch
)

src_unpack() {
	if [ "${PV}" = "9999" ]; then
		subversion_src_unpack
	else
		default
	fi
}

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
		CUSTOM_ENV=True
		DETECT_USERSPACE_ENV=False
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
