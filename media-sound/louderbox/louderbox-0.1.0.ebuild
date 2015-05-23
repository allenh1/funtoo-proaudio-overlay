# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Louderbox is a complete 8 band audio processor intended to be used
with software stereo and R[B]DS generators (but perfectly usable for other
things (such as web \"radio\")"
HOMEPAGE="http://nixbit.com/cat/multimedia/audio/louderbox/"
SRC_URI="http://www.sourcefiles.org/Multimedia/Mixers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${RDEPEND}
		>=media-sound/jack-audio-connection-kit-0.100
		>=media-libs/ladspa-sdk-0.12
		>=media-plugins/swh-plugins-0.4.7
		>=media-plugins/tap-plugins-0.7.0
		!media-sound/louderbox-cvs"
RDEPEND="=x11-libs/gtk+-2*
		=gnome-base/libglade-2*"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}

