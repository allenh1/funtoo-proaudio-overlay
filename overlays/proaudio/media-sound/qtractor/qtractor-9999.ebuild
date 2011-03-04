# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit flag-o-matic qt4-r2 subversion multilib exteutils

DESCRIPTION="Qtractor is an Audio/MIDI multi-track sequencer."
HOMEPAGE="http://qtractor.sourceforge.net/"

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug dssi ladspa libsamplerate mad osc rubberband vorbis sse vst"

RDEPEND=">=x11-libs/qt-core-4.2:4
	>=x11-libs/qt-gui-4.2:4
	x11-themes/qgtkstyle
	media-libs/alsa-lib
	media-libs/libsndfile
	media-libs/slv2
	media-sound/jack-audio-connection-kit
	ladspa? ( media-libs/ladspa-sdk )
	dssi? ( media-libs/dssi )
	mad? ( media-libs/libmad )
	libsamplerate? ( media-libs/libsamplerate )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? ( media-libs/libvorbis )
	vst? ( >=media-libs/vst-sdk-2.3 )"
DEPEND="${RDEPEND}"

src_prepare() {
	local regex='s!$! -L/usr/'$(get_libdir)'/qt4/plugins/styles -lgtkstyle!'
	esed_check -i "/^\s*LIBS\s*[+=]/ ${regex}" "${S}"/src/src.pri.in
}

src_configure() {
	append-flags "-DQT_STYLE_GTK"
	emake -f Makefile.svn

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

	append-ldflags "-Wl,-R,/usr/$(get_libdir)/qt4/plugins/styles"
	eqmake4 qtractor.pro -o qtractor.mak
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog TODO AUTHORS
}
