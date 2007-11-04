# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs qt4
# kde-functions
#need-qt 4

DESCRIPTION="a MIDI/Audio multi-track sequencer application"
HOMEPAGE="http://qtractor.sourceforge.net"

ECVS_SERVER="qtractor.cvs.sourceforge.net:/cvsroot/qtractor"
ECVS_MODULE="qtractor"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="vorbis mad"

DEPEND="$(qt4_min_version 4.1)
		>=media-sound/jack-audio-connection-kit-0.100.1
		>=media-libs/alsa-lib-0.9
		vorbis? ( >=media-libs/libvorbis-1.1.2 )
		mad? ( >=media-libs/libmad-0.15.1b )
		>=media-libs/libsamplerate-0.1.1
		>=media-libs/ladspa-sdk-1.12-r2"

src_compile() {
	emake -f Makefile.cvs
	#ugly qt4 configure hack
	sed -i '1iac_qtlib_version=set' configure
	
	econf \
		`use_enable vorbis libvorbis` \
		`use_enable mp3 libmad` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	doicon icons/${PN}.png
	make_desktop_entry ${PN} "Qtractor" ${PN} "Qt;AudioVideo;Audio;Sequencer"
	dodoc README AUTHORS ChangeLog TODO
}

