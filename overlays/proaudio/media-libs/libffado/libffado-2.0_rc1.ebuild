# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

MY_P="${P/_/-}"

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
SRC_URI="http://www.ffado.org/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug mixer optimization"

RDEPEND=">=media-libs/alsa-lib-1.0.0
	>=dev-cpp/libxmlpp-2.13.0
	>=sys-libs/libraw1394-1.3.0
	>=media-libs/libiec61883-1.1.0
	>=sys-libs/libavc1394-0.5.3
	>=sys-apps/dbus-1.0
	mixer? ( x11-libs/qt-core
			x11-libs/qt-gui
			dev-python/PyQt4
			>=dev-python/dbus-python-0.83.0 )"

DEPEND="${RDEPEND}
	dev-util/scons"

S="${WORKDIR}/${MY_P}"

src_compile () {
	local myconf="PREFIX=/usr LIBDIR=/usr/$(get_libdir)"

	use debug \
		&& myconf="${myconf} DEBUG=True" \
		|| myconf="${myconf} DEBUG=False"

	use optimization && myconf="${myconf} ENABLE_OPTIMIZATIONS=True"

	scons ${myconf} || die
}

src_install () {
	cd "$PN"
	scons DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
