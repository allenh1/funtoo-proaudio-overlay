# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion virtualx eutils toolchain-funcs qt4 patcher flag-o-matic

ESVN_REPO_URI="https://lmuse.svn.sourceforge.net/svnroot/lmuse/trunk/muse"
RESTRICT="ccache"

MY_PN=${PN/museseq/muse}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""
IUSE="doc dssi fluidsynth vst zynaddsubfx"

DEPEND="$(qt4_min_version 4.2.3)
	>=dev-util/cmake-2.4.7
	=sys-devel/gcc-4*
	>=media-libs/alsa-lib-1.0
	>=media-sound/fluidsynth-1.0.3
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.102.2
	dssi? ( >=media-libs/dssi-0.9.0 )
	lash? ( >=media-sound/lash-0.4.0 )
	!media-sound/museseq-cvs
	!media-sound/museseq-svn
	zynaddsubfx? ( =x11-libs/fltk-1.1*
			>=dev-libs/mini-xml-2 )
	vst? ( media-libs/fst )"

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

	# copy over correct header from ardour in case of amd64
	use amd64 && cp ${FILESDIR}/sse_functions_64bit.s al/dspSSE.cpp

	#patcher "${FILESDIR}/fix_zyn.patch apply"
	mkdir build

	# doc stuff
	use doc || sed -i -e 's@muse share doc@muse share@' CMakeLists.txt
}

src_compile() {
	# linking with --as-needed is broken :(
	filter-ldflags -Wl,--as-needed --as-needed

	cd "${S}/build"
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_DSSI="$(! use dssi; echo "$?")" \
		-DENABLE_VST="$(! use vst; echo "$?")" \
		-DENABLE_FLUID="$(! use fluidsynth; echo "$?")" \
		-DENABLE_ZYNADDSUBFX="0" \
		-DENABLE_ZYNADDSUBFX="$(! use zynaddsubfx; echo "$?")"

	use doc && cmake ../doc/CMakeLists.txt

	# workaround empty revision.h
	svn info ${ESVN_STORE_DIR}/${PN}/muse | grep Revision | \
		cut	-f 2 -d " " > ${S}/build/revision.h \
		|| die "generating revision.h failed"

	emake -j1 || die "build failed"
}

src_install() {
	cd "${S}/build"
	make DESTDIR=${D} install || die "install failed"
	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README SECURITY Reference
	mv "${D}/usr/bin/muse" "${D}/usr/bin/museseq-1.0"
	mv "${D}/usr/bin/grepmidi" "${D}/usr/bin/grepmidi-1.0"
	newicon "${S}/packaging/muse_icon.png" "museseq.png"
	make_desktop_entry "museseq-1.0" "MusE Sequencer 1.0" museseq \
		"AudioVideo;Audio;Sequencer"
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 1.0.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
}

