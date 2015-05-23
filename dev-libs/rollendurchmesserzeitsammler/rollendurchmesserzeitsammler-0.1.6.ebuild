# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-7.1-r1.ebuild,v 1.2 2011/11/13 18:56:12 vapier Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="The Rollendurchmesserzeitsamler conservative garbage collector for realtime audio"
HOMEPAGE="http://users.notam02.no/~kjetism/rollendurchmesserzeitsammler/"
SRC_URI="http://archive.notam02.no/arkiv/src/${P}.tar.gz
	http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.1.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="" #TODO: tlsf

pkg_setup() {
	ewarn "To compile with the correct optimisation, please"
	ewarn "emerge ${PN}"
	ewarn "when X is not running."
	ebeep 3
	epause 7
}

src_prepare() {
	sed -i -e "s~/usr/local~${D}/usr~" \
		-e "s~/etc/rollencurchmesserzeitsammler~rollendurchmesserzeitsammler~" \
		-e 's/OPT=-O3 -march=native/OPT=/' \
		-e "s/CC=gcc/CC=$(tc-getCC)/" \
		-e "s/CFLAGS=-Wall -g/CFLAGS=${CFLAGS}/" \
		-e 's~-DCONFFILE=\\"~-DCONFFILE=\\"/etc/~' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	emake -j1 || die
}

src_install() {
	mkdir -p ${D}/usr/include || die "mkdir inckude failed"
	mkdir -p ${D}/usr/lib || die "mkdir lib failed"

	emake DESTDIR="${D}" install || die

	insinto /etc
	doins rollendurchmesserzeitsammler.conf

	dodoc README
}
