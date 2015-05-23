# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="FreeST audio plugin VST container library"
HOMEPAGE="http://joebutton.co.uk/fst/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE=""

SRC_URI="http://galan.sf.net/${P}.tar.gz"
VST_SDK_VER="2.3"

KEYWORDS="x86"
RDEPEND="media-sound/lash
	>=app-emulation/wine-0.9.5
	>=media-sound/jack-audio-connection-kit-0.98.1
	=media-libs/vst-sdk-${VST_SDK_VER}*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if [ ! -e "/usr/include/vst/aeffectx.h" -a ! -e \
		"/usr/include/vst/aeffectx.h" ] ;then
		eerror "vst headerfiles not found"
		eerror "please emerge vst-sdk-2.3-r3 from the proaudio overlay"
		die "include files missing"
	fi
}

src_unpack() {
	unpack ${A} || die

	cd "${S}"
	einfo "Patch Makefile 0-5"
	sed -i  /test\ -n\ \$\(SDKDIR\)\ \&\&\ \$\(RM\)\ -rf\ \$\(SDKDIR\)/d "${S}"/Makefile || die

	# remove unneeded vars
	einfo "Patch Makefile 1-5"
	sed -i /distclean:clean/d  "${S}"/Makefile || die
	einfo "Patch Makefile 2-5"
	sed -i  /^SDKDIR/d "${S}"/Makefile || die
	einfo "Patch Makefile 3-5"
	sed -i  /^SDKDIR/d "${S}"/Makefile || die
	einfo "Patch Makefile 4-5"
	sed -i  /^VSTDIR/d "${S}"/Makefile || die
	einfo "Patch Makefile 5-5"

	# add VSTDIR include path to makefile
	sed -i -e 1i'VSTDIR = /usr/include/vst' "${S}"/Makefile || die

	# fix missing library flag
	sed -i -e 's@\(^LIBRARIES.*\)@\1 -lpthread@g' Makefile

	# hack to launch fst without lash server running
	epatch "${FILESDIR}"/${P}-if_no_lash_run.patch
}

src_compile() {
	emake || die
	# change path and name in the fst launch-script to
	# /usr/lib and libfst.so
	#sed -i -e "s:^\(appdir=''.*\):appdir='/usr/lib':" "${S}"/fst || die
	#sed -i -e "s:fst.exe.so:libfst.so:"  "${S}"/fst || die
	#sed -i '/dirname/d' "${S}"/fst || die
}

src_install() {
	exeinto /usr/bin
	doexe fst
	#fst.exe.so
	#fperms 644 /usr/bin/fst.exe.so
	# object files are needed for eg. ardour with fst-support
	insinto /usr/lib/"${PN}"
	doins *.o
	# install lib, so gcc -lfst works
	insinto /usr/lib
	newins fst.exe.so libfst.so
	dosym /usr/lib/libfst.so /usr/bin/fst.exe.so
	# install header-files
	insinto /usr/include
	doins fst.h
	insinto /usr/lib/pkgconfig
	doins "${FILESDIR}"/libfst.pc
	sed -i -e "s:^\(Version\:\)\(.*\):\1 ${PV}:"  "${D}"/usr/lib/pkgconfig/libfst.pc
}
