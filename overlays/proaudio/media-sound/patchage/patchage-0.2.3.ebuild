# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
IUSE="lash"
DESCRIPTION="Patchage is a modular patchbay for Jack audio and Alsa sequencer"
HOMEPAGE="http://www.nongnu.org/om-synth/"
SRC_URI="http://savannah.nongnu.org/download/om-synth/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND=">=media-sound/jack-audio-connection-kit-0.99
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/libgnomecanvasmm-2.6
	>=dev-cpp/libglademm-2.4.1
	lash? ( >=media-sound/lash-0.5.0 )
	!media-sound/patchage-cvs"

src_compile() {
	econf `use_enable lash` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS THANKS ChangeLog
}
