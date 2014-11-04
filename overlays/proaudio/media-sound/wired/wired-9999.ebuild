# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils autotools wxwidgets

DESCRIPTION="Wired aims to be a professional music production and creation software running on the Linux operating system."
HOMEPAGE="http://wired.sourceforge.net"

ESVN_REPO_URI="https://wired.svn.sourceforge.net/svnroot/wired/trunk"
ESVN_PROJECT="wired"
#ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls pic static debug dssi plugins codecs oss alsa jack portaudio-internal"
S="${WORKDIR}/${ESVN_PROJECT}"

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
	sys-devel/make
	!wired-svn/wired-svn"

src_compile() {
	cd "${S}"/wired

	WX_GTK_VER="2.6"
	need-wxwidgets unicode

	NOCONFIGURE=1 ./autogen.sh

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
	cd "${S}"/wired
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry ${PN} "Wired" ${PN} "AudioVideo;Audio;Sequencer;"
}
