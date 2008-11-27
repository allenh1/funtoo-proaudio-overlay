# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

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

pkg_setup() {
	if use amd64; then
		ewarn "This package is totally useless on amd64 as long our multilib setup"
		ewarn "is too poor to compile 32bit gnome-vfs and gstreamer (needed for"
		ewarn "32bit buzztard). BML does compile, but again: it's useless!"
		echo
		ewarn "Press Control-C in between 5 secs to cancel."
		echo
		sleep 5
		multilib_toolchain_setup x86
	fi
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
