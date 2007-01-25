# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="Om is a modular synthesizer for GNU/Linux audio systems using the Jack audio server and LADSPA or DSSI plugins."
HOMEPAGE="http://www.nongnu.org/om-synth/"
SRC_URI="http://savannah.nongnu.org/download/om-synth/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND=">=media-libs/liblo-0.22
	>=media-sound/jack-audio-connection-kit-0.99
	>=dev-libs/libxml2-2.6
	media-libs/dssi
	media-libs/ladspa-sdk
	media-plugins/omins
	>=dev-cpp/gtkmm-2.4 
	>=dev-cpp/libgnomecanvasmm-2.6 
	>=dev-cpp/libglademm-2.4.1"
	
src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS THANKS ChangeLog
}
	
