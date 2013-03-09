# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit subversion autotools-utils

DESCRIPTION="An Audio/MIDI multi-track sequencer."
HOMEPAGE="http://qtractor.sourceforge.net/"

ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug dssi ladspa libsamplerate lilv lv2 mad osc rubberband sse suil vorbis vst zlib"

RDEPEND=">=dev-qt/qtcore-4.2:4
	>=dev-qt/qtgui-4.2:4
	media-libs/alsa-lib
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	dssi? ( media-libs/dssi )
	ladspa? ( media-libs/ladspa-sdk )
	libsamplerate? ( media-libs/libsamplerate )
	lilv? ( || ( =media-sound/drobilla-9999 media-libs/lilv ) )
	lv2? ( || ( =media-sound/drobilla-9999 media-libs/lilv ) )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	suil? ( || ( =media-sound/drobilla-9999 media-libs/suil ) )
	vorbis? ( media-libs/libvorbis )
	vst? ( >=media-libs/vst-sdk-2.3 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND} sys-devel/autoconf sys-devel/autoconf-wrapper"

DOCS=( AUTHORS ChangeLog README TODO )
AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_AUTORECONF="1"

src_configure() {
	local myeconfargs=(	$(use_enable debug)
						$(use_enable dssi)
						$(use_enable ladspa)
						$(use_enable osc liblo)
						$(use_enable mad libmad)
						$(use_enable libsamplerate)
						$(use_enable lilv)
						$(use_enable lv2)
						$(use_enable rubberband librubberband)
						$(use_enable sse)
						$(use_enable suil)
						$(use_enable vorbis libvorbis)
						$(use_enable vst)
						$(use_enable zlib libz)
	)
	use vst && myconf+="--with-vst=${EPREFIX}/usr/include/vst"
	autotools-utils_src_configure
}
