# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils subversion autotools flag-o-matic qt4

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

ESVN_REPO_URI="https://lmms.svn.sourceforge.net/svnroot/lmms/trunk/lmms"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE="alsa debug flac jack ladspa oss pic samplerate sdl singerbot surround
stk vorbis vst sndfile"

DEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns )
		>=x11-libs/qt-4.3:4 )
	vorbis? ( media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	samplerate? ( media-libs/libsamplerate )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	vst? ( >=media-libs/vst-sdk-2.3-r3
			app-emulation/wine )
	ladspa? ( media-libs/ladspa-sdk )
	singerbot? ( app-accessibility/festival )
	stk? ( media-sound/stk )
	sndfile? ( media-libs/libsndfile )"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	# copy VST headers
	if use vst ; then
		cp /usr/include/vst/{AEffect.h,aeffectx.h} include/
	fi

	# fix Qt4 autofoo
	#epatch "${FILESDIR}/${P}-acinclude.patch"
}

src_compile() {
	unset QTDIR

	# autofoo
	eautoreconf || die

	# VST won't compile with -fomit-frame-pointer
	use vst && filter-flags "-fomit-frame-pointer"

	# configure options
	local myconf
	myconf="`use_with alsa asound` \
		`use_with oss` \
		`use_with vorbis` \
		`use_with samplerate libsrc` \
		`use_with sdl` \
		`use_with sdl sdlsound`\
		`use_with jack` \
		`use_with flac` \
		`use_with ladspa` \
		`use_with pic` \
		`use_enable surround` \
		`use_enable debug` \
		`use_with vst` \
		`use_with singerbot` \
		`use_with stk` \
		`use_with sndfile libsf` \
		--with-qtdir=/usr \
		--enable-hqsinc"

	econf ${myconf} || die "Configure failed"

	# we need MAKEOPTS="-j1" for VST support
	if use vst; then
		emake -j1 || die "Make failed"
	else
		emake || die "Make failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS ChangeLog TODO || die "dodoc failed"
	newicon "${D}/usr/share/lmms/themes/default/icon.png" "${PN}.png"
}
