# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
SRC_URI="http://ladish.org/download/ladish-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="lash python"

RDEPEND="!media-libs/lash
	media-sound/jack-audio-connection-kit[dbus]
	>=x11-libs/flowcanvas-0.6.4
	sys-apps/dbus
	>=dev-libs/glib-2.20.3
	>=x11-libs/gtk+-2.20.0
	>=gnome-base/libglade-2.6.2
	>=dev-libs/dbus-glib-0.74
	dev-lang/python
	>=dev-libs/expat-2.0.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}-include.patch"
}

src_configure() {
	python_convert_shebangs -r 2 "${S}"
	local myconf="--prefix=/usr --destdir=${D}"
	use lash && myconf="${myconf} --enable-liblash"
	use python && myconf="${myconf} --enable-pylash"
	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
}

src_compile() {
	einfo "Running \"./waf build\""
	./waf build || die "failed to build"
}

src_install() {
	einfo "Running \"./waf install --destdir=${ED}"
	./waf install --destdir="${ED}" || die "install failed"
	dodoc AUTHORS README NEWS
	python_convert_shebangs -r 2 "${ED}"
}
