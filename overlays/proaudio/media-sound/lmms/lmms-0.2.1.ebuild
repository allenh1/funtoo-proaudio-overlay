# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/lmms/lmms-0.1.4.ebuild,v 1.1.1.1 2006/04/10 11:32:49 gimpel Exp $

inherit eutils

RESTRICT="nomirror"
DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"

SRC_URI="mirror://sourceforge/lmms/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"


IUSE="alsa oggvorbis sdl samplerate jack"
DEPEND=">=x11-libs/qt-3.2.0
	oggvorbis? ( media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl 
		>=media-libs/sdl-sound-1.0.1 )
	samplerate? ( media-libs/libsamplerate )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	!media-sound/lmms-cvs"

#S="${WORKDIR}/${P}"
src_compile() {
	econf \
		`use_enable alsa asound` \
		`use_enable oggvorbis vorbis` \
		`use_enable samplerate` \
		`use_enable sdl` \
		`use_enable sdl sdlsound`\
		`use_enable jack` \
		"--enable-hqsinc" || die "Configure failed"

	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	make_desktop_entry lmms "Linux Multimedia Studio" "/usr/share/lmms/icon.png"
	dodoc README AUTHORS ChangeLog TODO
}
