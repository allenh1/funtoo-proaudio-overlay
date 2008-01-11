# Copyright 1999-2007 Gentoo Foundation
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

	# fixes some Makefile weirdness
	epatch "${FILESDIR}"/${P}-Makefile.patch

	# use our CFLAGS/CXXFLAGS instead
	sed -e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" -i libDSP/Makefile
	sed -e "s:^CXXFLAGS.*:CXXFLAGS = ${CXXFLAGS}:" -i DynThreads/Makefile

	# use our PREFIX too
	esed_check -i -e "s:^PREFIX.*:PREFIX = ${D}/usr:" Inlines/Makefile \
		libDSP/Makefile DynThreads/Makefile

	if use amd64;then
		esed_check -i -e "1iCFLAGS = ${CFLAGS}" \
			-e "s:\(^CFLAGS.*\):#\1:" \
			-e "s:\(^INCS.*\):INCS = -I. -I../Inlines -I/usr/include:" \
			libDSP/Makefile.x86-64

		esed_check -i -e "1iCXXFLAGS = ${CXXFLAGS}" \
			-e "s:\(^CXXFLAGS.*\):#\1:" \
			-e "s:\(^INCS.*\):INCS = -I. -I../Inlines -I/usr/include:" \
			DynThreads/Makefile.x86-64

		esed_check -i -e "s:^PREFIX.*:PREFIX = ${D}/usr:" \
			libDSP/Makefile.x86-64 DynThreads/Makefile.x86-64

	fi
	tc-export CC CXX
	# use our CC / CXX variables
	esed_check -i -e "s:^CC\ *=.*:CC = ${CC}:g" \
		-e "s:^CXX\ *=.*:CXX = ${CXX}:g" \
		libDSP/Makefile libDSP/Makefile.x86-64 \
		DynThreads/Makefile DynThreads/Makefile.x86-64

	# fix NPTL includes
	for filename in $(grep -rl nptl/pthread libDSP/* Inlines/* DynThreads/*); do
		esed_check -i -e "s:nptl/pthread.h:pthread.h:g"  $filename
	done

	# libtool only supports the --tag option from v1.5 onwards
	if ! has_version ">=sys-devel/libtool-1.5.0"; then
		esed_check -i -e "s/^LIBTOOL = libtool --tag=CXX/LIBTOOL = libtool/" libDSP/Makefile
		use amd64 && esed_check -i -e \
			"s/^LIBTOOL = libtool --tag=CXX/LIBTOOL = libtool/" libDSP/Makefile.x86_64
	fi
}

src_compile() {
	myconf=""
	use amd64 myconf="-f Makefile.x86-64"
	cd ${S}/DynThreads
	emake ${myconf} || die "DynThreads make failed!"

	cd ${S}/libDSP
	emake ${myconf} || die "libDSP make failed!"
}

src_install() {

	mkdir -p ${D}/usr/include
	cd ${S}/Inlines
	make install || die "Inlines install failed!"

	cd ${S}/DynThreads
	make ${myconf} install || die "DynThreads install failed!"

	cd ${S}/libDSP
	make ${myconf} install || die "libDSP install failed!"

	if use doc; then
		dohtml ${WORKDIR}/${PN}-doc-html/*
		docinto samples
		dodoc ${S}/libDSP/work/*
	fi
}
