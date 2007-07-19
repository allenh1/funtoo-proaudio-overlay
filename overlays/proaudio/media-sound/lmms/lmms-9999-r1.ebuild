# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools flag-o-matic

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

ESVN_REPO_URI="https://lmms.svn.sourceforge.net/svnroot/lmms/trunk/lmms"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE="alsa debug flac jack ladspa oss pic samplerate sdl surround stk vorbis vst qt3 qt4"
DEPEND="qt4? ( >=x11-libs/qt-4.1 ) 
	qt3? ( =x11-libs/qt-3.3* )
	vorbis? ( media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl 
		>=media-libs/sdl-sound-1.0.1 )
	samplerate? ( media-libs/libsamplerate )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	vst? ( >=media-libs/vst-sdk-2.3-r3 
			app-emulation/wine )
	ladspa? ( media-libs/ladspa-sdk )"

pkg_setup() {
	if use qt4; then
		if use qt3; then
			die "Please choose qt3 OR qt4 in USE"
		fi
	fi
}
src_unpack() {
	subversion_src_unpack
	cd ${S}
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
		`use_with stk` \
		--enable-hqsinc"
	
	# qt4 fixups
	if use qt4; then
		myconf="${myconf} --with-qtdir=/usr"
		#epatch ${FILESDIR}/lmms-qt4_configure_gentoo.patch
	fi

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
	make_desktop_entry ${PN} "Linux Multimedia Studio" ${PN} \
		"AudioVideo;Audio;Sequencer" 
}
