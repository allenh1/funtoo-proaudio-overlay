# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tool for creating an AC-3 (Dolby Digital) multichannel stream from its JACK input ports"
HOMEPAGE="http://essej.net/ac3jack/"
SRC_URI="http://essej.net/ac3jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>media-libs/aften-0.0.8
	>=media-video/ffmpeg-0.4.6
	>=media-sound/jack-audio-connection-kit-0.80.0
	x11-libs/wxGTK
	dev-libs/boost
	media-libs/liblo
	>=dev-libs/libsigc++-1.2"
DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/"${P}"-compile-fix.patch
}

src_install(){
	dodoc README NEWS
	make DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry "${PN}" ac3jack "${PN}" "AudioVideo;Audio;SoundProcessing"
}
