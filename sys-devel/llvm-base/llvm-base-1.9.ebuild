# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

MY_P="${P/-base/}"

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.cs.uiuc.edu/releases/${PV}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="llvm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="jit"

DEPEND="sys-devel/bison
		sys-devel/flex
		dev-lang/perl
		=sys-devel/llvm-gcc-1.9"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	sed -i -e 's/-C//' ${S}/docs/Makefile || die
	sed -i -e 's/-C//' ${S}/docs/CommandGuide/Makefile || die
	sed -i -e 's/OPTIONAL_DIRS/#OPTIONAL_DIRS/' ${S}/Makefile || die
	sed -i -e 's/@prefix@\//${PROJ_prefix}\//' ${S}/Makefile.config.in || die
}

src_compile() {
	local mytarget
	[ "${ARCH}" = "x86" ] && mytarget="x86"
	[ "${ARCH}" = "amd64" ] && mytarget="ia64"
	
	econf \
		`use_enable jit` \
		--enable-targets="${mytarget}" \
		|| die
	
	emake tools-only || die
}

src_install() {
	make PROJ_prefix="${D}/usr" install || die
	rm -f ${D}/usr/*/.dir
	rm -f ${D}/usr/*/*/.dir
	mv "${D}/usr/etc" "${D}/etc"
	mv "${D}/usr/docs/llvm/*" "${D}/usr/share/${P}/"
}
