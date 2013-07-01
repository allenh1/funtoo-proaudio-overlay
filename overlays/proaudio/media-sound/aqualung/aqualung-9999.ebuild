# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
inherit autotools-utils eutils subversion

IUSE="alsa cdda cddb debug encode flac ffmpeg ifp jack ladspa lame
libsamplerate loop-playback lua mac mad modplug musepack oss podcast
pulseaudio sndfile speex systray vorbis wavpack"

DESCRIPTION="Aqualung is a music player capable of gapless playback. \
Not very suitable for eye candy seekers."
HOMEPAGE="http://aqualung.factorial.hu/"

ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

RDEPEND="alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio )
	cddb? ( amd64? ( >=media-libs/libcddb-1.3.0 ) )
	encode? ( lame? ( media-sound/lame ) )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	ifp? ( media-libs/libifp )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	lua? ( dev-lang/lua )
	mac? ( media-sound/mac )
	mad? ( media-libs/libmad )
	modplug? ( media-libs/libmodplug )
	musepack? ( >=media-sound/musepack-tools-444 )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( >=media-libs/libsndfile-1.0.12 )
	speex? ( media-libs/speex media-libs/liboggz )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	wavpack? ( >=media-sound/wavpack-4.40.0 )
	>=x11-libs/gtk+-2.6"

DEPEND="${RDEPEND}
	ladspa? ( >=media-libs/liblrdf-0.4.0 )
	virtual/pkgconfig
	dev-libs/libxml2
	media-libs/raptor"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	subversion_wc_info

	echo "#define AQUALUNG_VERSION \"R-${ESVN_WC_REVISION}\"" > src/version.h

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with alsa)
		$(use_with cdda)
		$(use_with cddb)
		$(use_with ffmpeg lavc)
		$(use_with flac)
		$(use_with ifp)
		$(use_with jack)
		$(use_with ladspa)
		$(use_with libsamplerate src)
		$(use_with lua)
		$(use_with mac)
		$(use_with mad mpeg)
		$(use_with modplug mod)
		$(use_with musepack mpc)
		$(use_with oss)
		$(use_with pulseaudio pulse)
		$(use_with sndfile)
		$(use_with speex)
		$(use_with vorbis)
		$(use_with wavpack)
		$(use_enable debug)
		$(use_enable loop-playback loop)
		$(use_enable podcast)
		$(use_enable systray)
	)
	if use encode; then
		myeconfargs+=(
			$(use_with lame)
			$(use_with vorbis vorbisenc)
			--enable-transcoding
		)
	else
		myeconfargs+=(
			--without-lame
			--without-vorbisenc
			--disable-transcoding
		)
	fi

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newicon -s 64 src/img/icon_64.png "${PN}.png"
	make_desktop_entry "${PN}" "${PN/a/A}" "${PN}" "Audio;AudioVideo"
}
