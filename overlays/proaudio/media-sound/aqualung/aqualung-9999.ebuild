# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion base eutils autotools

IUSE="alsa cdda cddb debug flac ffmpeg ifp jack ladspa libsamplerate loop-playback lua mac mad modplug mp3 musepack oss podcast pulseaudio sndfile speex systray vorbis wavpack"

DESCRIPTION="Aqualung is a music player capable of gapless playback.
Not very suitable for eye candy seekers."
HOMEPAGE="http://aqualung.sourceforge.net"
SRC_URI=""

ESVN_REPO_URI="https://aqualung.svn.sourceforge.net/svnroot/aqualung/trunk"
ESVN_PROJECT="aqualung"
ESVN_PATCHES=""

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

RDEPEND="vorbis? ( >=media-libs/libvorbis-1.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.12 )
	flac? ( media-libs/flac )
	modplug? ( media-libs/libmodplug )
	alsa? ( virtual/alsa )
	lua? ( dev-lang/lua )
	mac? ( media-sound/mac )
	mp3? ( media-libs/libmad )
	musepack? ( media-libs/libmpcdec )
	ffmpeg? ( virtual/ffmpeg )
	ifp? ( media-libs/libifp )
	pulseaudio? ( media-sound/pulseaudio )
	speex? ( media-libs/speex media-libs/liboggz )
	wavpack? ( >=media-sound/wavpack-4.40.0 )
	cddb? ( !amd64? ( >=media-libs/libcddb-1.2.1 ) )
	cddb? ( amd64? ( >=media-libs/libcddb-1.3.0 ) )
	jack? ( media-sound/jack-audio-connection-kit )
	cdda? ( dev-libs/libcdio )
	libsamplerate? ( media-libs/libsamplerate )
	>=x11-libs/gtk+-2.6"

DEPEND="${RDEPEND}
	ladspa? ( >=media-libs/liblrdf-0.4.0 )
	>=dev-util/pkgconfig-0.9.0
	dev-libs/libxml2
	media-libs/raptor"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	# subversion.eclass strips the .svn folder, so i'm injecting a version.h
	echo "#define AQUALUNG_VERSION \"R-$(cd
"${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}" ; svn info |
grep '^Revision' | awk '{print $2}')\"" > src/version.h

	eautoreconf || die
}

src_compile() {
	econf \
		`use_with flac` \
		`use_with vorbis ogg` \
		`use_with sndfile` \
		`use_with alsa` \
		`use_with mad mpeg` \
		`use_with oss` \
		`use_with jack` \
		`use_with mac` \
		`use_with mod` \
		`use_with musepack mpc` \
		`use_with ffmpeg lavc` \
		`use_with ifp` \
		`use_with speex` \
		`use_with wavpack` \
		`use_with cddb` \
		`use_with systray` \
		`use_with ladspa` \
		`use_with lua` \
		`use_with cdda` \
		`use_with loop-playback loop` \
		`use_with podcast` \
		`use_with pulseaudio pulse` \
		`use_with libsamplerate src` \
		`use_enable debug` \
		|| die "econf failed"

	emake || die "make failed"
}

DOCS="AUTHORS ChangeLog INSTALL NEWS README"
