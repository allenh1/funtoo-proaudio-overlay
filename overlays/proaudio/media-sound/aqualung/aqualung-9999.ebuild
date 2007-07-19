# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils autotools

IUSE="sndfile mod mad vorbis speex flac musepack ffmpeg taglib ladspa cddb cdda jack alsa oss systray debug loop-playback wavpack"

MY_P="aqualung"

DESCRIPTION="Aqualung"
HOMEPAGE="http://aqualung.sourceforge.net"
SRC_URI=""

ESVN_REPO_URI="https://aqualung.svn.sourceforge.net/svnroot/aqualung/trunk"
ESVN_PROJECT="aqualung"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

RDEPEND="oggvorbis? ( >=media-libs/libvorbis-1.0 )
	libsndfile? ( >=media-libs/libsndfile-1.0.12 )
	flac? ( media-libs/flac )
	mod? ( media-libs/libmodplug )
	alsa? ( virtual/alsa )
	mp3? ( media-libs/libmad )
	musepack? ( media-libs/libmpcdec )
	ffmpeg? ( media-video/ffmpeg )
	speex? ( media-libs/speex media-libs/liboggz )
	wavpack? ( >=media-sound/wavpack-4.40.0 )
	cddb? ( !amd64? ( >=media-libs/libcddb-1.2.1 ) )
	cddb? ( amd64? ( >=media-libs/libcddb-1.3.0 ) )
	jack? ( media-sound/jack-audio-connection-kit )
	taglib? ( >=media-libs/taglib-1.4 )
	cdda? ( >=dev-libs/libcdio-0.76 )
	media-libs/libsamplerate"

DEPEND="systray? ( >=x11-libs/gtk+-2.10 )
	loop-playback? ( >=x11-libs/gtk+-2.8 )
	ladspa? ( >=media-libs/liblrdf-0.4.0 )
	>=dev-util/pkgconfig-0.9.0
	virtual/libc
	>=x11-libs/gtk+-2.6
	dev-libs/libxml2
	media-libs/raptor
	!media-sound/aqualung-cvs
	${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	# subversion.eclass strips the .svn folder, so i'm injecting a version.h
	echo "#define AQUALUNG_VERSION \"R-$(cd "${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}" ; svn info | grep '^Revision' | awk '{print $2}')\"" > src/version.h
}

src_compile() {
	eautoreconf || die
	econf \
		`use_with flac` \
		`use_with vorbis ogg` \
		`use_with sndfile` \
		`use_with alsa` \
		`use_with mad mpeg` \
		`use_with oss` \
		`use_with jack` \
		`use_with mod` \
		`use_with musepack mpc` \
		`use_with ffmpeg lavc` \
		`use_with speex` \
		`use_with wavpack` \
		`use_with cddb` \
		`use_with systray` \
		`use_with ladspa` \
		`use_with taglib metadata` \
		`use_with cdda` \
		`use_with loop-playback loop` \
		`use_enable debug` \
		|| die "econf failed"
	
	emake || die "make failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
} 
