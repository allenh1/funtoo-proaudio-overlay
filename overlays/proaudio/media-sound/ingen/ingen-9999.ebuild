# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils autotools

RESTRICT="nomirror"
# lash currently not supported upstream
IUSE="dssi pic jackmidi midi ladspa lv2 jack osc gtk2"
DESCRIPTION="Ingen (successor of om) is a modular synthesizer for GNU/Linux audio systems using the Jack audio server and LADSPA or DSSI plugins."
HOMEPAGE="http://drobilla.net/software/ingen"

ESVN_REPO_URI="http://svn.drobilla.net/lad/${PN}"

LICENSE="GPL-2"
KEYWORDS=""

RDEPEND=">=media-libs/liblo-0.22
	>=sys-libs/raul-9999
	lash? ( >=media-sound/lash-0.5.0 )
	>=media-sound/jack-audio-connection-kit-0.102.20
	midi? ( >=media-libs/alsa-lib-1.0.0 )
	( >=dev-libs/libxml2-2.6
		>=dev-cpp/glibmm-2.4
		>=media-libs/raptor-0.21
		>=dev-libs/rasqal-0.9.11
		>=dev-libs/libsigc++-2.0 )
	gtk2? ( >=dev-cpp/gtkmm-2.4 
		>=dev-cpp/libgnomecanvasmm-2.6 
		>=dev-cpp/libglademm-2.4
		>=media-libs/flowcanvas-9999 )
	media-libs/dssi
	ladspa? ( media-libs/ladspa-sdk )
	media-plugins/omins
	!media-sound/om
	dssi? ( media-libs/dssi )
	!media-sound/om-cvs
	jack? ( media-sound/jack-audio-connection-kit )
	jackmidi? ( >=media-sound/jack-audio-connection-kit-0.100.7-r2 )
	lv2? ( media-libs/slv2 )"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	dev-util/pkgconfig"

pkg_setup() {
	ewarn "if the compilation fails you can try to re-emerge"
	ewarn "media-libs/flowcanvas-9999 and sys-libs/raul-9999"
	ewarn "as ingen depens atm. on their latest code"
	sleep 3s
	if ! built_with_use sys-libs/raul osc ; then
	    echo
		eerror "this app need rauls osc support"
		eerror "re-emerge sys-libs/raul with useflag osc"
		eerror "and then try this one again"
		die 
	fi
}
src_unpack() {
	subversion_src_unpack
	cd "${s}"
	# quick fixes 
	sed -e 's@#include <asoundlib.h>@#include <alsa/asoundlib.h>@g' -i \
		src/libs/engine/DSSINode.h
	#sed -i -e 's@\(^ingen_load_LDADD.*\)@\1 -lrasqal@g' \
	#	src/progs/patch_loader/Makefile.*
}

src_compile() {
	export WANT_AUTOCONF=2.6
	export WANT_AUTOMAKE=1.10
	eautoreconf
	#NOCONFIGURE=1 ./autogen.sh
	
	JACK_CFLAGS=`pkg-config --cflags jack` \
	JACK_LIBS=`pkg-config --libs jack` \
	ALSA_CFLAGS=`pkg-config --cflags alsa` \
	ALSA_LIBS=`pkg-config --libs alsa` \
	econf \
		`use_with pic` \
		`use_enable jackmidi jack-midi` \
		`use_enable midi jack-midi` \
		`use_enable dssi` \
		`use_enable lash` \
		`use_enable ladspa` \
		`use_enable osc server` \
		`use_enable gtk2 gtk-client` \
		`use_enable jack in-process-engine` \
		`use_enable lv2` || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README THANKS NEWS TODO ChangeLog
}
