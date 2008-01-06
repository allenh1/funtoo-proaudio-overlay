# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"

inherit exteutils qt4 toolchain-funcs versionator
MY_P="${PN}-$(replace_version_separator "3" "-")"
S="${WORKDIR}/$(replace_version_separator "4" "" "${MY_P}")"

DESCRIPTION="Digital DJ tool using QT 4.x"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="mirror://sourceforge/mixxx/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

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

IUSE="alsa jack ladspa djconsole hifieq exbpm exrecord"

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
	unpack "${A}"
	cd "${S}"
	# use our own CXXFLAGS/CFLAGS
	esed_check -i \
		-e "0,/\(^env.Append.*\)/s//\1\nenv.Append(CCFLAGS = Split(\"\"\" \
		${CFLAGS} \"\"\"))/" \
		-e "0,/\(^env.Append.*\)/s//\1\nenv.Append(CXXFLAGS = ' ${CXXFLAGS} ')/" \
		src/SConscript
}

src_compile() {
	myconf=""
	! use ladspa; myconf="ladspa=$?"
	myconf="${myconf} ffmpeg=0"
	! use djconsole; myconf="${myconf} djconsole=$?"
	! use hifieq; myconf="${myconf} hifieq=$?"
	! use exbpm; myconf="${myconf} experimentalbpm=$?"
	! use exrecord; myconf="${myconf} experimentalrecord=$?"
	myconf="${myconf} prefix=/usr"

	mkdir -p "${D}/usr"
	einfo "selected options: ${myconf}"
	tc-export CC CXX
	scons ${myconf} || die "scons failed"
}

src_install() {
	mkdir -p "${D}/usr"
	einfo "selected options: ${myconf}"
	scons ${myconf} install_root="${D}/usr" install || die
	dodoc README Mixxx-Manual.pdf
}
