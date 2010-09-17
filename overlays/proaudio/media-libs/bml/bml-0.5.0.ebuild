# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

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

src_prepare() {
	# Removed 'static' due to a gcc4 new
	sed -e "s/static int vsscanf/int vsscanf/" -i "${S}/dllwrapper/wine/win32.c"
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

pkg_postinst() {
	if use amd64; then
		echo
		ewarn "AMD64 users please note that you will not be able to load 32bit"
		ewarn "machines! To get some native 64bit ones, install	media-plugins/buzzmachines"
		echo
	fi
}
