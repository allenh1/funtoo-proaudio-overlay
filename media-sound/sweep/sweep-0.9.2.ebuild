# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

RESTRICT="mirror"
DESCRIPTION="audio editor and live playback tool"
HOMEPAGE="http://www.metadecks.org/software/sweep/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc x86"
IUSE="alsa mp3 nls speex vorbis"

DEPEND="media-libs/libsamplerate
	>=media-libs/libsndfile-1.0
	speex? ( media-libs/speex )
	mp3? ( >=media-sound/madplay-0.14.2b )
	>=x11-libs/gtk+-2.0
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	nls? ( sys-devel/gettext )
	vorbis? ( media-libs/libogg media-libs/libvorbis )"

src_unpack() {
	unpack ${A}
	cd ${S}
	#epatch ${FILESDIR}/${P}-alsa.patch
}

src_compile() {
	econf \
		$(use_enable alsa) \
		$(use_enable nls) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable speex) \
		$(use_enable mp3 mad) \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	sed -i -e "s/AudioVideo;/AudioVideo;AudioVideoEditing;/" \
		"${D}/usr/share/applications/${PN}.desktop"
}

pkg_postinst() {
	einfo
	einfo "Sweep can use ladspa plugins,"
	einfo "emerge ladspa-sdk and ladspa-cmt if you want them."
	einfo
}
