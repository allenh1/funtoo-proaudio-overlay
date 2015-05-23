# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 waf-utils

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
SRC_URI="http://${PN}.org/download/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc lash python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	python? ( lash )"

# Gentoo bug #477734
RDEPEND="!media-libs/lash
	media-sound/jack-audio-connection-kit[dbus]
	>=x11-libs/flowcanvas-0.6.4
	sys-apps/dbus
	>=dev-libs/glib-2.20.3
	>=x11-libs/gtk+-2.20.0
	>=gnome-base/libglade-2.6.2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/expat-2.0.1
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

PATCHES=( "${FILESDIR}/${P}-include.patch" )

src_configure() {
	NO_WAF_LIBDIR="yes"
	local mywafconfargs=(
		$(usex doc --doxygen "")
		$(usex lash --enable-liblash "")
		$(usex python --enable-pylash "")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	use doc && HTML_DOCS=( "${S}/build/default/html/" )
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
