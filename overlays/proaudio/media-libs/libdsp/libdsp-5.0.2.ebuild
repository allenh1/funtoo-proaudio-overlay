# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils toolchain-funcs

DESCRIPTION="C++ class library of common digital signal processing functions."
HOMEPAGE="http://libdsp.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.gz
		doc? ( mirror://sourceforge/${PN}/${PN}-doc-html.tar.gz )"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ~amd64 -sparc"
IUSE="doc"
DEPEND=""

S=${WORKDIR}/${PN}-src-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	local ap_arch=""

	if use x86;then
		ap_arch=""
		# disable assembler optimization (gcc 4 fails)
		esed_check -i -e "s@\(^DEFS.*-DDSP_X86\)@# \1@" \
			-e "s@^#\(DEFS.*-DUSE_MEMMOVE\)@\1@" "libDSP/Makefile"
	fi

	use amd64 && ap_arch=".x86-64"

	# begin -- patch make files
	patch_prefix "Inlines/Makefile" "libDSP/Makefile${ap_arch}" \
		"DynThreads/Makefile${ap_arch}"

	patch_cflags_include "libDSP/Makefile${ap_arch}" \
		"DynThreads/Makefile${ap_arch}"

	patch_used_compiler "libDSP/Makefile${ap_arch}" \
		"DynThreads/Makefile${ap_arch}"

	patch_libtool "libDSP/Makefile${ap_arch}"

	patch_optcflags "libDSP/Makefile${ap_arch}"
	# end -- patch make files

	# fix NPTL includes
	for filename in $(grep -rl nptl/pthread libDSP/* Inlines/* DynThreads/*); do
		esed_check -i -e "s:nptl/pthread.h:pthread.h:g"  $filename
	done
}

patch_cflags_include() {
		esed_check -i -e "1iCFLAGS = ${CFLAGS}" \
			-e "s:\(^CFLAGS.*\):#\1:" \
			-e "s:\(^INCS.*\):INCS = -I. -I../Inlines -I/usr/include:" \
			-e "1iCXXFLAGS = ${CXXFLAGS}" \
			-e "s:\(^CXXFLAGS.*\):#\1:" $@
}

patch_optcflags() {
	#remove optional flags
	esed_check -i -e "s:\(^OPTCFLAGS.*\):#\1:" $@
}

patch_prefix() {
	# use our PREFIX too
	esed_check -i -e "s:^PREFIX.*:PREFIX = ${D}/usr:" $@
}

patch_used_compiler() {
	# use our CC / CXX variables
	tc-export CC CXX
	esed_check -i -e "s:^CC\ *=.*:CC = ${CC}:g" \
		-e "s:^CXX\ *=.*:CXX = ${CXX}:g" $@

}

patch_libtool() {
	# libtool only supports the --tag option from v1.5 onwards
	if ! has_version ">=sys-devel/libtool-1.5.0"; then
		esed_check -i -e "s/^LIBTOOL = libtool --tag=CXX/LIBTOOL = libtool/" $@
	fi
}

src_compile() {
	myconf=""
	use x86 && myconf=""
	use amd64 && myconf="-f Makefile.x86-64"
	cd "${S}"/DynThreads
	emake ${myconf} || die "DynThreads make failed!"

	cd "${S}"/libDSP
	emake ${myconf} || die "libDSP make failed!"
}

src_install() {

	mkdir -p "${D}"/usr/include
	cd "${S}"/Inlines
	make install || die "Inlines install failed!"

	cd "${S}"/DynThreads
	make ${myconf} install || die "DynThreads install failed!"

	cd "${S}"/libDSP
	make ${myconf} install || die "libDSP install failed!"

	if use doc; then
		dohtml "${WORKDIR}"/${PN}-doc-html/*
		docinto samples
		dodoc "${S}"/libDSP/work/*
	fi
}
