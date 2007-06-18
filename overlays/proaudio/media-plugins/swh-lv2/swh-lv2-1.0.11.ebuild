# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils
RESTRICT="nomirror"
DESCRIPTION="Large collection of lv2 audio plugins/effects (swh-plugins)"
HOMEPAGE="http://plugin.org.uk/lv2/"
SRC_URI="http://plugin.org.uk/lv2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"

RDEPEND=""

src_unpack() {
	unpack "${A}" 
	cd "${S}"
	esed_check -i -e 's@gcc@$(CC)@g' \
		-e 's@^PREFIX.*@PREFIX = /usr@g' \
		-e 's@\(^INSTALL_DIR.\=\.*[^\$]\)\(.*\)@\1$(DESTDIR)\2@g' Makefile

}
src_install() {
	make DESTDIR=${D} install-system || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
}

