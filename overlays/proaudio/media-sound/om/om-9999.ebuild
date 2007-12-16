# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

RESTRICT="nomirror"
IUSE="dssi pic lash jackmidi"
DESCRIPTION="Om is a modular synthesizer for GNU/Linux audio systems using the Jack audio server and LADSPA or DSSI plugins."
HOMEPAGE="http://www.nongnu.org/om-synth/"

ECVS_SERVER="cvs.savannah.nongnu.org:/sources/om-synth"
ECVS_MODULE="om-synth"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=">=media-libs/liblo-0.22
	>=media-sound/jack-audio-connection-kit-0.99
	>=dev-libs/libxml2-2.6
	media-libs/dssi
	media-libs/ladspa-sdk
	media-plugins/omins
	>=dev-cpp/gtkmm-2.4 
	>=dev-cpp/libgnomecanvasmm-2.6 
	>=dev-cpp/libglademm-2.4.1
	>=media-libs/flowcanvas-0.1.0
	lash? ( media-sound/lash )
	dssi? ( media-libs/dssi )
	!media-sound/om-cvs"
S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	# we will need that one.. horribly failed to fix for gcc41
	# epatch "${FILESDIR}"/"${P}"-gcc41.patch
	# fix lash
	epatch "${FILESDIR}"/om-src-engine-LashDriver.cpp.diff
	NOCONFIGURE=1 ./autogen.sh
	econf \
		`use_with pic` \
		`use_enable jackmidi jack-midi` \
		`use_enable dssi` \
		`use_enable lash` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
}
