# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic qt4-r2 subversion multilib exteutils

DESCRIPTION="Qtractor is an Audio/MIDI multi-track sequencer."
HOMEPAGE="http://qtractor.sourceforge.net/"

ESVN_REPO_URI="http://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug dssi ladspa libsamplerate lv2 mad osc rubberband sse suil vorbis vst zlib"

RDEPEND=">=x11-libs/qt-core-4.2:4
	>=x11-libs/qt-gui-4.2:4
	media-libs/alsa-lib
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	dssi? ( media-libs/dssi )
	ladspa? ( media-libs/ladspa-sdk )
	libsamplerate? ( media-libs/libsamplerate )
	lv2? ( || ( =media-sound/drobilla-9999 media-libs/lilv ) )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	suil? ( || ( =media-sound/drobilla-9999 media-libs/suil ) )
	vorbis? ( media-libs/libvorbis )
	vst? ( >=media-libs/vst-sdk-2.3 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND} sys-devel/autoconf sys-devel/autoconf-wrapper"

src_configure() {
	emake -f Makefile.svn

	local myconf
	use vst && myconf="--with-vst=/usr/include/vst"

	econf \
		$(use_enable debug) \
		$(use_enable dssi) \
		$(use_enable ladspa) \
		$(use_enable osc liblo) \
		$(use_enable mad libmad) \
		$(use_enable libsamplerate) \
		$(use_enable lv2) \
		$(use_enable rubberband librubberband) \
		$(use_enable sse) \
		$(use_enable suil) \
		$(use_enable vorbis libvorbis) \
		$(use_enable vst) \
		$(use_enable zlib libz) \
		$(myconf) \
		|| die "econf failed"

	eqmake4 qtractor.pro -o qtractor.mak
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog TODO AUTHORS
}
