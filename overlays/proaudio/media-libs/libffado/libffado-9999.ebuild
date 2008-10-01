# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils

IUSE="debug profile"

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk"


LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND=">=media-libs/alsa-lib-1.0.0
	>=dev-cpp/libxmlpp-2.13.0
	>=sys-libs/libraw1394-1.3.0
	>=media-libs/libiec61883-1.1.0
	>=sys-libs/libavc1394-0.5.3
	>=sys-apps/dbus-1.0
	=media-sound/jack-audio-connection-kit-9999"

DEPEND="${RDEPEND}
	dev-util/scons"

src_compile () {
	cd "$PN"
	escons \
		$(scons_use_enable debug DEBUG) \
		$(scons_use_enable profile PROFILE) \
		CFLAGS="${CFLAGS}" \
		PREFIX="/usr/"
}
src_install () {
	cd "$PN"
	escons DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
