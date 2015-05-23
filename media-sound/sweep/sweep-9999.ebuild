# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

RESTRICT="mirror"
DESCRIPTION="audio editor and live playback tool"
HOMEPAGE="http://www.metadecks.org/software/sweep/"
#SRC_URI="http://www.metadecks.org/software/sweep/download/${P}.tar.bz2"
ESVN_REPO_URI="http://svn.metadecks.org/sweep/trunk"
ESVN_PROJECT="sweep"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa nls vorbis"
S="${WORKDIR}/${ESVN_PROJECT}"

DEPEND="media-libs/libsamplerate
	>=media-libs/libsndfile-1.0
	media-libs/speex
	>=media-sound/madplay-0.14.2b
	>=x11-libs/gtk+-2.0
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	nls? ( sys-devel/gettext )
	vorbis? ( media-libs/libogg media-libs/libvorbis )"

src_compile() {
	NOCONFIGURE=1 ./autogen.sh
	econf \
		$(use_enable alsa) \
		$(use_enable nls) \
		$(use_enable vorbis) \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"
}

pkg_postinst() {
	einfo
	einfo "Sweep can use ladspa plugins,"
	einfo "emerge ladspa-sdk and ladspa-cmt if you want them."
	einfo
}
