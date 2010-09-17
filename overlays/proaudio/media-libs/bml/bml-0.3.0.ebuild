# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib

DESCRIPTION="Buzz Machines Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="app-emulation/wine"
RDEPEND="${DEPEND}"

pkg_setup() {
	use amd64 && multilib_toolchain_setup x86
}

src_prepare() {
	sed -e "s/static int vsscanf/int vsscanf/" -i \
	"${S}/dllwrapper1/wine/win32.c"
}

src_configure() {
	econf $(use_enable debug) || die "Configure failed"
}

src_compile() {
	emake -j1 || die "Compilation failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
