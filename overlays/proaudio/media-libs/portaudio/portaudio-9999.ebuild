# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-libs/portaudio/portaudio-19.ebuild,v 1.1.1.1 2006/04/10 11:22:11 gimpel Exp $

inherit eutils subversion #fetch-tools 
ESVN_REPO_URI="https://www.portaudio.com/repos/portaudio/branches/v19-devel"
DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
SRC_URI=""
url="http://portaudio.com/archives/pa_snapshot_v19.tar.gz"

SLOT="19"
LICENSE="GPL-2"
KEYWORDS=""

IUSE="jack alsa oss doc"

RDEPEND="virtual/libc"
DEPEND="app-arch/unzip
	jack? ( >=media-sound/jack-audio-connection-kit-0.100.0 )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	dev-util/scons"
S=${WORKDIR}/${PN}

src_unpack() {
	#fetch_tarball_cmp "${url}"
	#unpack pa_snapshot_v19.tar.gz
	subversion_src_unpack
}

src_compile() {
	scons_compile(){
		mkdir -p ${D}/usr
		local myconf="enableShared=1 prefix=${D}/usr enableStatic=0 enableAsserts=0"
		! use jack;	myconf="${myconf} useJACK=$?"
		! use alsa; myconf="${myconf} useALSA=$?"
		! use oss; myconf="${myconf} useOSS=$?"
		einfo "${myconf}"
		scons configure ${myconf} customCFlags="${CFLAGS}" || return 1 # "configure failed"
		scons ${MAKEOPTS} || return 1 # "scons failed"
		return 0
	}

	make_compile() {
		econf $(use_with alsa) $(use_with jack) \
			$(use_with oss)|| return 1 #die "econf failed"
		emake || return 1 #die "emake failed"
		return 0
	}
	ewarn "using scons build system"
	scons_compile
	if [ $? == "1" ];then
		build_tool="auto"
		ewarn "scons failded trying autotools"
		make_compile || die "die configure/build"
	else
		build_tool="scons"
	fi
}

src_install() {
	if [ "${build_tool}" == "scons" ];then
		dodir /usr
		scons install DESTDIR="${D}/usr" || die "scons failed to install"
		use doc && dodoc docs/*
	else
#		if ! use ppc-macos;then
#			dolib lib/*
#			dosym /usr/$(get_libdir)/libportaudio.so.0.0.19 /usr/$(get_libdir)/libportaudio.so
#		else
#			dolib pa_mac_core/libportaudio.dylib
#		fi
		emake  DESTDIR="${D}" install || die "install failed"
		
		insinto /usr/include
		doins include/portaudio.h
		use doc && dodoc docs/*
	fi
}

pkg_postinst(){
	einfo "If you update from portaudio-19 to portaudio-19-r1"
	einfo "and have troubles with apps using portaudio you need to run:"
	einfo
	einfo "revdep-rebuild --library=libportaudio.so.*"
	einfo
	einfo "to fix apps which linked against portaudio-19"
}

