# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="${P/_/-}"

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
SRC_URI="http://www.ffado.org/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug profile"

RDEPEND=">=media-libs/alsa-lib-1.0.0
	>=dev-cpp/libxmlpp-2.13.0
	>=sys-libs/libraw1394-1.3.0
	>=media-libs/libiec61883-1.1.0
	>=sys-libs/libavc1394-0.5.3
	>=sys-apps/dbus-1.0"

DEPEND="${RDEPEND}
	dev-util/scons"

src_compile () {
	cd "$PN"
	scons \
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
