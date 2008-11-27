# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Buzz Machines Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="app-emulation/wine"
RDEPEND="${DEPEND}"

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

pkg_postinst() {
	if use amd64; then
		echo
		ewarn "AMD64 users please note that you will not be able to load 32bit"
		ewarn "machines! To get some native 64bit ones, install	media-plugins/buzzmachines"
		echo
	fi
}
