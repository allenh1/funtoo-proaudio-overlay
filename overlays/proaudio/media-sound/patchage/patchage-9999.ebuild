# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

RESTRICT="nomirror"
IUSE="lash"
DESCRIPTION="Patchage is a modular patchbay for Jack audio and Alsa sequencer."
HOMEPAGE="http://drobilla.net/software/patchage"


ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=">=media-libs/liblo-0.22
	>=media-sound/jack-audio-connection-kit-0.107.0
	>=dev-libs/libxml2-2.6
	>=dev-libs/glib-2.14.0
	>=dev-cpp/glibmm-2.14.0
	>=dev-cpp/gtkmm-2.11.12
	>=dev-cpp/libgnomecanvasmm-2.6
	>=dev-cpp/libglademm-2.6.0
	>=x11-libs/flowcanvas-0.5.1
	dev-libs/dbus-glib
	lash? ( media-sound/lash )
	=media-libs/raul-9999"


src_compile() {
	cd ${PN}

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die
	./waf build ${MAKEOPTS} || die
}

src_install() {
	cd ${PN}
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc README
}
