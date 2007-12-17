# Copyright 1999-2007777777 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit virtualx eutils toolchain-funcs qt4 patcher

MY_PN=${PN/museseq/muse}
MY_P="${MY_PN}-${PV/_/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE="vst dssi fluidsynth zynaddsubfx"

DEPEND=">=dev-util/cmake-2.4.1
		=sys-devel/gcc-4*"
RDEPEND="${DEPEND}
	$(qt4_min_version 4.2.3)
	>=media-libs/alsa-lib-1.0
	>=media-sound/fluidsynth-1.0.3
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	=media-sound/jack-audio-connection-kit-0.102.2*
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
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
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

	emake || die "build failed"
}

src_install() {
	cd "${S}/build"
	make DESTDIR="${D}" install || die "install failed"
	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README SECURITY Reference
	mv "${D}/usr/bin/muse" "${D}/usr/bin/museseq-1.0"
}

pkg_postinst() {
	einfo "You will need write access to the realtime clock."
	einfo "See
	http://proaudio.tuxfamily.org/wiki/index.php?title=Realtime_%28RT%29_Kernel#Activate_and_test_RT"
	einfo "on how to set that up."
}

