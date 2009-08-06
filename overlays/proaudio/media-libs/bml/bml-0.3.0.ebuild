# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Buzz Machines Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="app-emulation/wine"
RDEPEND="${DEPEND}"

pkg_setup() {
	use amd64 && multilib_toolchain_setup x86
}

src_compile() {
	econf \
		`use_enable debug ` \
		|| die "Configure failed"
	emake -j1 || die "Compilation failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
