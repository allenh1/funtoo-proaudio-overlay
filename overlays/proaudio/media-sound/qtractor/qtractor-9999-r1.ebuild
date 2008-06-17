# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4 cvs

DESCRIPTION="Qtractor is an Audio/MIDI multi-track sequencer."
HOMEPAGE="http://qtractor.sourceforge.net/"

ECVS_SERVER="qtractor.cvs.sourceforge.net:/cvsroot/qtractor"
ECVS_MODULE="qtractor"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug dssi ladspa libsamplerate mad osc rubberband vorbis sse vst"

DEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui )
			>=x11-libs/qt-4.1:4 )
	media-libs/alsa-lib
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	ladspa? ( media-libs/ladspa-sdk )
	dssi? ( media-libs/dssi )
	mad? ( media-libs/libmad )
	libsamplerate? ( media-libs/libsamplerate )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	vst? ( >=media-libs/vst-sdk-2.3 )"

pkg_setup() {
	if ! built_with_use --missing true media-libs/alsa-lib midi; then
		eerror ""
		eerror "To be able to build ${CATEGORY}/${PN} with ALSA support you"
		eerror "need to have built media-libs/alsa-lib with midi USE flag."
		die "Missing midi USE flag on media-libs/alsa-lib"
	fi
}

src_compile() {
	make -f Makefile.cvs

	local myconf
	use vst && myconf="--with-vst=/usr/include/vst"

	econf \
		$(use_enable mad libmad) \
		$(use_enable libsamplerate) \
		$(use_enable vorbis libvorbis) \
		$(use_enable osc liblo) \
		$(use_enable ladspa) \
		$(use_enable dssi) \
		$(use_enable rubberband librubberband) \
		$(use_enable sse) \
		$(use_enable debug) \
		${myconf} \
		|| die "econf failed"
	eqmake4 qtractor.pro -o qtractor.mak
	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog TODO AUTHORS
}
