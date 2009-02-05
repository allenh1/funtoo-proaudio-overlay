# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion eutils toolchain-funcs cmake-utils flag-o-matic

ESVN_REPO_URI="https://lmuse.svn.sourceforge.net/svnroot/lmuse/trunk/muse"
RESTRICT="ccache"

MY_PN=${PN/museseq/muse}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""
IUSE="doc dssi fluidsynth lash vst zynaddsubfx"

DEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns
		x11-libs/qt-qt3support x11-libs/qt-svg )
		>=x11-libs/qt-4.2:4[qt3support] )
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
	zynaddsubfx? ( =x11-libs/fltk-1.1*
			>=dev-libs/mini-xml-2 )
	vst? ( media-libs/fst )"

src_unpack() {
	subversion_src_unpack
	cd ${S}

	# copy over correct header from ardour in case of amd64
	use amd64 && cp ${FILESDIR}/sse_functions_64bit.s al/dspSSE.cpp

	# find fltk
	epatch "${FILESDIR}/${P}-find_fltk.patch"

	# doc stuff
	use doc || sed -i -e 's@muse share doc@muse share@' CMakeLists.txt
}

src_configure() {
	# linking with --as-needed is broken :(
	filter-ldflags -Wl,--as-needed --as-needed
	
	# work around -lQtSvg not found error
	append-flags "-L/usr/$(get_libdir)/qt4"
	append-ldflags "-L/usr/$(get_libdir)/qt4"

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_enable dssi DSSI)
		$(cmake-utils_use_enable vst VST)
		$(cmake-utils_use_enable fluidsynth FLUID)
		$(cmake-utils_use_enable zynaddsubfx ZYNADDSUBFX)
		"
	cmake-utils_src_configure
	
	# workaround empty revision.h
	svn info ${ESVN_STORE_DIR}/${PN}/muse | grep Revision | \
		cut	-f 2 -d " " > ${WORKDIR}/${PN}_build/revision.h \
		|| die "generating revision.h failed"

}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README SECURITY Reference"
	cmake-utils_src_install

	mv "${D}/usr/bin/muse" "${D}/usr/bin/museseq-2.0"
	mv "${D}/usr/bin/grepmidi" "${D}/usr/bin/grepmidi-2.0"
	newicon "${S}/packaging/muse_icon.png" "museseq.png"
	make_desktop_entry "museseq-2.0" "MusE Sequencer 2.0" museseq \
		"AudioVideo;Audio;Sequencer"
}
