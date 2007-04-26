# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils scons-ccache fetch-tools 

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

URL_PREFIX="http://ardour.org/files/releases"
SRC_URI="" #"${URL_PREFIX}${PN}-cvs.tar.bz2"
RESTRICT="nomirror"
MY_A=${PN}-cvs.tar.bz2
URL="${URL_PREFIX}/${MY_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls debug sse altivec vst"

# From beta30 release notes:
#  plugin latency compensation now working correctly (we believe)
#  This really requires JACK 0.100.0 or above to work
#  properly, but even without that, they result in notable improvements
#  in the way Ardour aligns newly recorded material.
#
# As media-sound/jack-audio-connection-kit-0.100.0 is still -arch and it is not required for beta30
# only suggested, RDEPEND needs to be updated as media-sound/jack-audio-connection-kit-0.100.0 gets
# into ~arch. (2005 Sep 14 eldad)

RDEPEND="dev-util/pkgconfig
	>=media-libs/liblrdf-0.3.6
	>=media-libs/raptor-1.2.0
	>=media-sound/jack-audio-connection-kit-0.98.1
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=media-libs/libsndfile-1.0.4
	sys-libs/gdbm
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsamplerate-0.0.14
	>=dev-libs/libxml2-2.5.7
	>=media-libs/libart_lgpl-2.3.16
	!media-sound/ardour-cvs"

DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )
	vst? ( >=media-libs/fst-1.7-r3 )"

fetch_cvs_tarball() {
DOWNLOAD=n
	if [ "${#PORTAGE_ACTUAL_DISTDIR}" == "0" ];then
		PORTAGE_ACTUAL_DISTDIR="${DISTDIR}"
	fi
	if [  -e "${PORTAGE_ACTUAL_DISTDIR}/${PN}-cvs.tar.bz2" ];then
		einfo "ardour.org does not offer real cvs-support"
		einfo "it just gives us daily snapshots:"
		einfo "your snapshot is from: `LC_ALL=C ls /usr/portage/distfiles/ardour-cvs.tar.bz2  --time-style=long-iso -l| awk '{print $6}'`"
		einfo "Do you want Re-download ardour-cvs tarball? [y,n]"
		read DOWNLOAD
	else
		DOWNLOAD="y"
	fi
	if [ "${DOWNLOAD}" == "y" ];then
	 	addwrite "${PORTAGE_ACTUAL_DISTDIR}/${MY_A}"
		rm -f "${PORTAGE_ACTUAL_DISTDIR}/${MY_A}"
		wget ${URL_PREFIX}/${MY_A} -P "${PORTAGE_ACTUAL_DISTDIR}" ||\
		die "cannot fetch new ardour-cvs-patch"
	fi
}

S="${WORKDIR}/${PN}"

pkg_setup(){
	# issue with ACLOCAL_FLAGS if set to a wrong value
	if [ "${#ACLOCAL_FLAGS}" -gt "0" ];then
		ewarn "check your profile settings:"
		ewarn "There is no need to set the ACLOCAL_FLAGS"
		ewarn "environment variable so we unset it"
		unset ACLOCAL_FLAGS
	fi
}

src_unpack(){
	# following 3 lines replaced by eclass and unpack	
	##fetch_cvs_tarball
	##echo ">>> Unpacking ${PORTAGE_ACTUAL_DISTDIR}/${MY_A} to >>> ${WORKDIR}"
	##tar -xjpf "${PORTAGE_ACTUAL_DISTDIR}/${MY_A}" || die "unpacking failed"
	fetch_tarball_cmp "${URL}"
	unpack "${URL##*/}"
	cd ${S}
	use vst && epatch ${FILESDIR}/ardour-vst-support_0_1.patch
	use vst && epatch ${FILESDIR}/ardour-vst-support_1_1.patch
	add_ccache_to_scons
}

src_compile() {
	# bug 99664
	cd ${S}/libs/gtkmm
	chmod a+x autogen.sh && ./autogen.sh || die "autogen failed"
	econf || die "configure failed"
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	local myconf=""
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?"
	! use vst; myconf="${myconf} VST=$? VSTPATH=/usr/lib/fst"
	! use sse; myconf="${myconf} USE_SSE_EVERYWHERE=$? BUILD_SSE_OPTIMIZATIONS=$?"
	
	# static settings
	myconf="${myconf} DESTDIR=${D} PREFIX=/usr KSI=0"
	einfo "${myconf}"

	cd ${S}
	scons ${myconf}	-j2 || die "compilation failed"
}

src_install() {
	scons install || die "make install failed"
	use vst && dobin gtk_ardour/ardour.bin.exe.so
	use vst && fperms 644 /usr/bin/ardour.bin.exe.so
	dodoc DOCUMENTATION/*
}
