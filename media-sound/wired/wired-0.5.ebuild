# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
inherit eutils wxwidgets

DESCRIPTION="Wired aims to be a professional music production and creation software"
HOMEPAGE="http://wired.sourceforge.net"
SRC_URI="mirror://sourceforge/wired/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="nls pic static debug dssi plugins codecs oss alsa jack portaudio-internal"

S="${WORKDIR}/${PN}"

## Gui related
RDEPEND="${RDEPEND}
	virtual/libc
	>=x11-libs/gtk+-2.0
	>=x11-libs/wxGTK-2.6.0"

## Sound related
RDEPEND=">=media-libs/libsndfile-1.0
	media-libs/alsa-lib
	media-libs/libsamplerate
	plugins? ( >=media-libs/libsoundtouch-1.2.1 )
	dssi? ( >=media-libs/dssi-0.9 )
	codecs? ( media-libs/libvorbis
			media-libs/flac )
	portaudio-internal? ( !media-libs/portaudio )
	!portaudio-internal? ( =media-libs/portaudio-19* )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	WX_GTK_VER=2.8
	need-wxwidgets unicode

	local myconf
	myconf=""
	use portaudio-internal || myconf="--disable-portaudio"
	econf \
		--with-wx-config=/usr/lib/wx/config/gtk2-ansi-release-2.6 \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with oss) \
	    $(use_enable debug ) \
	    $(use_enable dssi ) \
	    $(use_enable codecs ) \
	    $(use_enable plugins ) \
		$(use_enable nls) \
		$(use_with pic) \
		$(use_with static) \
		${myconf} \
		|| die "Configuration failed"
	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS BUGS INSTALL LICENSE NEWS README TODO CHANGELOG
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry ${PN} "Wired" ${PN} "AudioVideo;Audio;Sequencer;"
}
