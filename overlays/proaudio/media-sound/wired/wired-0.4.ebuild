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
	!portaudio-internal? ( >=media-libs/portaudio-19 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/libtool
	sys-devel/make"

pkg_setup() {
	if ! built_with_use x11-libs/wxGTK X ; then
		die "x11-libs/wxGTK MUST be compiled with GTK2 or X support"
	fi
}

src_compile() {
	libtoolize --copy --force
	local myconf
	myconf=""
	use portaudio-internal || myconf="--disable-portaudio"
	econf \
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
	make install DESTDIR=${D} || die "Install failed"
	dodoc AUTHORS BUGS INSTALL LICENSE NEWS README TODO CHANGELOG
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry ${PN} "Wired" ${PN} "AudioVideo;Audio;Sequencer;"
}
