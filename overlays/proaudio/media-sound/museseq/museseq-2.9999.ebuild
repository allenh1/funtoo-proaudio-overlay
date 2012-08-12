# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2"

inherit subversion eutils toolchain-funcs cmake-utils flag-o-matic python

MY_PN=${PN/museseq/muse2}
ESVN_REPO_URI="https://lmuse.svn.sourceforge.net/svnroot/lmuse/trunk/${MY_PN}"

S=${WORKDIR}/${MY_PN}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""
IUSE="doc +dssi -experimental fluidsynth lash optimization +osc -python -vst"

RDEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns
		x11-libs/qt-qt3support x11-libs/qt-svg )
		>=x11-libs/qt-4.2:4[qt3support] )
	>=media-libs/alsa-lib-1.0
	>=media-sound/fluidsynth-1.0.3
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.102.2
	dssi? ( >=media-libs/dssi-0.9.0
		media-plugins/dssi-vst )
	lash? ( >=media-sound/lash-0.4.0 )
	vst? ( >=media-libs/fst-9999 )"

DEPEND="
	>=dev-util/cmake-2.4.7
	=sys-devel/gcc-4*
	doc? ( dev-texlive/texlive-context
		app-text/openjade
		app-doc/doxygen
		media-gfx/graphviz )
	sys-apps/util-linux"

if use optimization ; then
	CMAKE_BUILD_TYPE="Release"
fi

pkg_setup() {
	if use osc ; then
		if ! use dssi ; then
			ewarn "You enabled the osc use flag, it won't build without"
			ewarn "the dssi use flag!"
			die
		fi
	fi
	if use vst ; then
		ewarn "vst is onsoleted, considere to use dssi instead."
	fi
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	cd "${MY_S}" || die "cd failed"

	# copy over correct header from ardour in case of amd64
	use amd64 && cp "${FILESDIR}/sse_functions_64bit.s" al/dspSSE.cpp || die "cd failed"
	
	# patch gor correct build with USE=experimental
	sed -i -e 's:-DBUILD_EXPERIMENTAL ${CMAKE_CXX_FLAGS}:"-DBUILD_EXPERIMENTAL ${CMAKE_CXX_FLAGS}":' \
	${S}/CMakeLists.txt || die "sed failed"
}

src_configure() {
	# linking with --as-needed is broken :(
#	filter-ldflags -Wl,--as-needed --as-needed

	# work around -lQtSvg not found error
#	append-flags "-L/usr/$(get_libdir)/qt4"
#	append-ldflags "-L/usr/$(get_libdir)/qt4"

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_enable dssi DSSI)
		$(cmake-utils_use_enable experimental EXPERIMENTAL)
		$(cmake-utils_use_enable osc OSC)
		$(cmake-utils_use_enable fluidsynth FLUID)
		$(cmake-utils_use_enable zynaddsubfx ZYNADDSUBFX)
		$(cmake-utils_use_enable python PYTHON)
		$(cmake-utils_use_enable vst VST)
		"

	cmake-utils_src_configure

	# workaround empty revision.h
#	svn info ${ESVN_STORE_DIR}/${PN}/muse | grep Revision | \
#		cut	-f 2 -d " " > "${WORKDIR}/${PN}_build/revision.h" \
#		|| die "generating revision.h failed"

}

src_install() {
	DOCS=""
	cmake-utils_src_install

	mv "${D}/usr/bin/grepmidi" "${D}/usr/bin/grepmidi2"
	mv "${D}/usr/share/man/man1/grepmidi.1" "${D}/usr/share/man/man1/grepmidi2.1" || die
}
