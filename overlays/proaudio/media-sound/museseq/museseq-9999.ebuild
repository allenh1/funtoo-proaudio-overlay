# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion virtualx eutils toolchain-funcs qt4 patcher

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/lmuse/trunk/muse"

MY_PN=${PN/museseq/muse}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""
IUSE="vst dssi fluidsynth zynaddsubfx"

DEPEND="$(qt4_min_version 4.2.3)
	>=dev-util/cmake-2.4.1
	=sys-devel/gcc-4*
	>=media-libs/alsa-lib-1.0
	>=media-sound/fluidsynth-1.0.3
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.102.1
	dssi? ( >=media-libs/dssi-0.9.0 )
	lash? ( >=media-sound/lash-0.4.0 )
	!media-sound/museseq-cvs
	!media-sound/museseq-svn
	zynaddsubfx? ( =x11-libs/fltk-1.1* 
			>=dev-libs/mini-xml-2 )"

pkg_setup() {
	if ! built_with_use ">=x11-libs/qt-4" qt3support; then
		eerror "atm $PN needs qt3support "
		eerror "You will have to compile >=qt-4 with USE=\"qt3support\"."
		die
	fi
	
	# check if libfst is valid
#	if [ -e "/usr/lib/pkgconfig/libfst.pc"	];then
#		egrep -q '1.8|1.7' /usr/lib/pkgconfig/libfst.pc &>/dev/null && \
#		eerror "try to update fst: at least to fst-1.8-r3 or uninstall fst
# or just remove /usr/lib/pkgconfig/libfst.pc" && die
#	fi
}

src_unpack() {
	subversion_src_unpack
	cd ${S}
	patcher "${FILESDIR}/fix_zyn.patch apply"
	mkdir build
}

src_compile() {
	cd "${S}/build"
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_DSSI="$(! use dssi; echo "$?")" \
		-DENABLE_VST="$(! use vst; echo "$?")" \
		-DENABLE_FLUID="$(! use fluidsynth; echo "$?")" \
		-DENABLE_ZYNADDSUBFX="0" \
		-DENABLE_ZYNADDSUBFX="$(! use zynaddsubfx; echo "$?")" 

	cmake ../doc/CMakeLists.txt

	# correct some wrong generated files for zynaddsubfx

	emake || die "build failed"
}

src_install() {
#	cd "${S}"/build
	#sed -i -e "s:/usr/local:/usr:" CMakeCache.txt
	cd "${S}/build"
	make DESTDIR=${D} install || die "install failed"
	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README SECURITY Reference
	mv "${D}/usr/bin/muse" "${D}/usr/bin/museseq-1.0"
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 1.0.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
}

