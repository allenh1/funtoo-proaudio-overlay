# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"

inherit eutils git-2 toolchain-funcs

DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui:a=summary"
SRC_URI=""
LICENSE="Mikkosoft"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/udev
	sys-apps/pmount
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_prepare() {
	# Respect CFLAGS and LDFLAGS
	sed -i -e 's:-Wall -Wextra:${CFLAGS} ${LDFLAGS}:' Makefile || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin pmount-gui
	dodoc README.txt
}
