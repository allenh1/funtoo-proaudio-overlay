# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools flag-o-matic

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="alsa debug flac jack ladspa oss pic samplerate sdl singerbot surround stk vorbis vst"

DEPEND="=x11-libs/qt-3.3*
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
	stk? ( media-sound/stk )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# copy VST headers
	if use vst ; then
		cp /usr/include/vst/{AEffect.h,aeffectx.h} include/
	fi
}

src_compile() {
	# autofoo
	eautoreconf || die
	
	# VST won't compile with -fomit-frame-pointer
	use vst && filter-flags "-fomit-frame-pointer"

	econf \
		`use_with alsa asound` \
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
		--enable-hqsinc \
		|| die "Configure failed"
	
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
	make_desktop_entry ${PN} "Linux Multimedia Studio" ${PN} \
		"AudioVideo;Audio;Sequencer" 
}
