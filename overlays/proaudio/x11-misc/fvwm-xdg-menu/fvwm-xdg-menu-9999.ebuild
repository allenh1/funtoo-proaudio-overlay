# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2

EGIT_REPO_URI="git://github.com/domichel/fvwm-xdg-menu.git"

DESCRIPTION="xdg menu for use with fvwm and fvwm-menu-desktop"
HOMEPAGE="https://github.com/domichel/fvwm-xdg-menu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README.md
}
