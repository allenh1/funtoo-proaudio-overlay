# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.7.1.ebuild,v 1.4 2005/05/15 14:43:25 flameeyes Exp $

#inherit kde-functions 
inherit subversion virtualx eutils toolchain-funcs qt4
#need-qt 4

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/lmuse/trunk/muse"
#ESVN_PROJECT="muse"

MY_PN=${PN/museseq/muse}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="doc dssi fluidsynth"

DEPEND="$(qt4_min_version 4.2)
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
	>=media-sound/jack-audio-connection-kit-0.98.0
	dssi? ( media-libs/dssi )
	lash? ( >=media-sound/lash-0.4.0 )
	!media-sound/museseq-cvs
	!media-sound/museseq-svn"

pkg_setup() {
	if ! built_with_use sys-libs/glibc nptl; then
		eerror "JUCE needs POSIX threads in order to work."
		eerror "You will have to compile glibc with USE=\"nptl\"."
		die
	fi
	# check if libfst is valid
	if [ -e "/usr/lib/pkgconfig/libfst.pc"	];then
		egrep -q '1.8|1.7' /usr/lib/pkgconfig/libfst.pc &>/dev/null && \
		eerror "try to update fst: at least to fst-1.8-r3 or uninstall fst
 or just remove /usr/lib/pkgconfig/libfst.pc" && die
	fi
}

src_compile() {
#	cd "${S}"
#	QTDIR=/usr
#	#not sure yet if these work:
#	use dssi || ENABLE_DSSI=OFF
#	#use vst && ENABLE_VST=ON
#	use fluidsynth && ENABLE_FLUID=ON
#	./gen || die "make failed"
	#mkdir muse                    # create build directory
	#cd muse                       # enter build directory
	#cmake ../muse             # create make system
	cmake CMakeLists.txt 
	cd doc; make CMakeLists.txt;cd -
	emake || die "build failed"


}

src_install() {
	cd "${S}"/build
	sed -i -e "s:/usr/local:/usr:" CMakeCache.txt
	make DESTDIR=${D} install || die "install failed"
	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README SECURITY Reference
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 1.0.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
}

