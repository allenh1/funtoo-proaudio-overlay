# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Flake is a flac encoder."
HOMEPAGE="http://flake-enc.sourceforge.net/"
SRC_URI="mirror://sourceforge/flake-enc/${P}.tar.bz2"
LICENSE="LGPL"
SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""
DEPEND=""

src_compile() {
	# the configure script doesn't take a whole lot of options, so econf didn't work
	./configure --prefix=/usr || die "./configure failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
