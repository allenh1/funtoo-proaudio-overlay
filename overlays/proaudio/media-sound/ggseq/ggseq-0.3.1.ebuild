# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/ggseq/ggseq-0.3.1.ebuild,v 1.1.1.1 2006/04/10 10:35:21 gimpel Exp $

RESTRICT="mirror"
inherit wxwidgets

DESCRIPTION="Gungirl Sequencer is an easy to use Audiosequencer"
HOMEPAGE="http://ggseq.sourceforge.net"
SRC_URI="mirror://sourceforge/ggseq/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="media-libs/portaudio
		>=x11-libs/wxGTK-2.4.2
		>=media-libs/libsamplerate-0.1.0
		>=media-libs/portaudio-18.1
		>=media-libs/libsndfile-1.0.10
		media-libs/libsamplerate
		>=media-libs/libsoundtouch-1.2.1"

src_unpack() {
	unpack ${A} || die "Unpacking the source failed"
	cd "${S}" || die "Could not change directory."
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	einstall || die "Install failed"
}
