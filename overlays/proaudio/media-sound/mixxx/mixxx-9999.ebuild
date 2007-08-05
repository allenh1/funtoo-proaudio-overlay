# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 subversion

DESCRIPTION="Digital DJ tool using QT 4.x"
HOMEPAGE="http://mixxx.sourceforge.net"

ESVN_REPO_URI="https://mixxx.svn.sourceforge.net/svnroot/mixxx/trunk/mixxx"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="$(qt4_min_version 4.3)
	media-sound/madplay
	media-libs/libogg
	media-libs/libvorbis
	media-libs/audiofile
	media-libs/libsndfile
	media-libs/libsamplerate
	media-libs/libid3tag
	=media-libs/portaudio-19*
	virtual/glu
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	djconsole? ( media-libs/libdjconsole )
	ffmpeg? ( media-video/ffmpeg 
			media-sound/gsm 
			media-libs/libdc1394 
			sys-libs/libraw1394 
			media-libs/libdts 
			media-libs/a52dec )
	ladspa? ( media-libs/ladspa-sdk )"

RDEPEND="${DEPEND}
	 dev-lang/perl"

DEPEND="${DEPEND}
	sys-apps/sed
	dev-util/scons
	dev-util/pkgconfig"

IUSE="alsa jack ffmpeg ladspa djconsole hifieq exbpm exrecord"

pkg_setup() {
	if use jack; then
		if ! built_with_use media-libs/portaudio jack; then
			eerror "To have jack support, you need to compile portaudio"
			eerror "with USE=\"jack\"!"
			die
		fi
	fi
	# we need qt4 with opengl and qt3support
	if ! built_with_use x11-libs/qt qt3support; then
		eerror "You need to compile qt4 with USE="\"qt3support\"!"
		die
	elif ! built_with_use x11-libs/qt opengl; then
		eerror "You need to compile qt4 with USE="\"opengl\"!"
		die
	fi
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	# fix qt4 include path mess
	epatch "${FILESDIR}/${P}-qt4_paths.patch"
	# use our own CXXFLAGS
	sed -i -e "s:-pipe -O3 -pipe:${CXXFLAGS}:" src/SConscript || die
}

src_compile() {
	local myconf=""
	use ladspa && myconf="ladspa=1"
	use ffmpeg && myconf="${myconf} ffmpeg=1"
	use djconsole && myconf="${myconf} djconsole=1"
	use hifieq && myconf="${myconf} hifieq=1"
	use exbpm && myconf="${myconf} experimentalbpm=1"
	use exrecord && myconf="${myconf} experimentalrecord=1"

	unset QTDIR
	mkdir -p "${D}/usr"
	scons \
		prefix="${D}/usr" \
		${myconf} \
		|| die "scons failed"
}

src_install() {
	mkdir -p "${D}/usr"
	scons prefix="${D}/usr" install || die
	dodoc README Mixxx-Manual.pdf
}
