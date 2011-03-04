# Copyright 1999-2011 Mat
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI="3"

inherit base autotools git

DESCRIPTION="dbus-c++ attempts to provide a C++ API for D-BUS."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/dbus-c++"

EGIT_REPO_URI="git://gitorious.org/dbus-cplusplus/mainline.git"
: ${EGIT_COMMIT:=9ac4f0252f0784e8594b41e578e6d04f89835d13}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug glib"

ACLOCAL_AMFLAG="-I config"
MAKEOPTS+=" -j1"

# probably needs more/less crap listed here ...
RDEPEND="sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf \
		--disable-doxygen-docs \
		$(use_enable debug) \
		$(use_enable glib) \
		|| die "configure failed"
}
