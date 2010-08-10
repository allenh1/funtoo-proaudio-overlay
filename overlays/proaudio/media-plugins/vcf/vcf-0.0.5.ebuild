# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib toolchain-funcs

DESCRIPTION="VCF LADSPA plugin filters"
HOMEPAGE="http://www.suse.de/~mana/ladspa.html"
SRC_URI="http://www.suse.de/~mana/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND=""

src_compile() {
	tc-export CC
	# try to obey CC, CFLAGS and LDFLAGS
	epatch "${FILESDIR}/${P}-makefile.patch"
	emake || die "emake failed"
}

src_install() {
	# no make install...
	insopts -m0755
	insinto /usr/$(get_libdir)/ladspa
	doins *.so
}
