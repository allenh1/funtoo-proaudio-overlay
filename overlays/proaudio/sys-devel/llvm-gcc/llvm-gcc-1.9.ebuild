# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils toolchain-funcs

MY_PN="${PN}$(gcc-major-version)"
MY_P="${MY_PN}-${PV}.source"

DESCRIPTION="C, C++ Frontend for Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.cs.uiuc.edu/releases/${PV}/${MY_P}.tar.gz
		http://llvm.cs.uiuc.edu/releases/${PV}/llvm-${PV}.tar.gz"

LICENSE="llvm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="threads"

DEPEND=">=sys-devel/gcc-4"

S="${WORKDIR}/${MY_P}"
LLVMOBJDIR="${WORKDIR}/llvm-${PV}"

pkg_setup() {
	if [ "$(gcc-major-version)" = "3" ]; then
		eerror "This ebuild currently only supports gcc-4*"
		die
	fi
}

src_compile() {
	# first we need to compile llvm itself
	cd ${LLVMOBJDIR}
	local mytarget
	[ "${ARCH}" = "x86" ] && mytarget="x86"
	[ "${ARCH}" = "amd64" ] && mytarget="ia64"
	econf \
	    --enable-targets="${mytarget}" \
		|| die
	make ENABLE_OPTIMIZED=1

	# now we can compile llvm-gcc
	cd "${S}"
	epatch "${FILESDIR}/${P}-dwarf_fix.patch"

	mkdir build
	cd build
	replace-flags "-march=pentium-m" "-march=pentium3"
	../configure \
		--prefix=/usr \
		`use_enable threads` \
		--disable-nls \
		--disable-shared \
		--enable-languages=c,c++ \
		--enable-llvm=${LLVMOBJDIR} \
		--program-prefix=llvm-
	emake || die
}

src_install() {
	cd "${S}"/build
	make DESTDIR="${D}" install || die
	rm -R "${D}"/usr/man "${D}"/usr/info 
	rm "${D}"/usr/lib/*.*
}
