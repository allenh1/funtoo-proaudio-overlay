# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit git-2 python-single-r1 waf-utils

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/expat-2.0.1
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_unpack() {
	git-2_src_unpack
}

src_configure() {
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
