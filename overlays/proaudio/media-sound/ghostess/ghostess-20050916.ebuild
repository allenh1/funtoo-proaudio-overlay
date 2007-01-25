# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit jackmidi
RESTRICT="nomirror"
IUSE="jackmidi"
DESCRIPTION="graphical DSSI host, based on jack-dssi-host"
HOMEPAGE="http://home.jps.net/~musound/"
SRC_URI="http://home.jps.net/~musound/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND=">=media-libs/dssi-0.9.1
	>=x11-libs/gtk+-2.0
	dev-util/pkgconfig
	>=media-libs/liblo-0.18
	>=media-libs/ladspa-sdk-1.0
	jackmidi? ( media-sound/jack-audio-connection-kit )
	>=media-libs/ladspa-sdk-1.0"

src_unpack() {
	use jackmidi && need_jackmidi
	unpack ${P}.tar.gz
	einfo Patching configure.ac
	sed -i -e'/jack_midi_port_get_info/'i"AC_ARG_WITH\(jackmidi,AC_HELP_STRING([--with-jackmidi], [default=yes]),\n\t[ if test \$withval \= \"yes\";then with_jack_midi\=yes;\n\t\telse with_jack_midi=no; fi ])\nif test "x\${with_jack_midi}" = 'xyes'; then" ${S}/configure.ac
	sed -i '/AC_DEFINE(MIDI_ALSA/'d  ${S}/configure.ac
	sed -i -e'/AM_CONDITIONAL(MIDI_JACK/'i"else if test x\${darwin} = 'xno'; then\n\tAC_DEFINE(MIDI_ALSA, 1, [Define for ALSA MIDI support on Linux])\nfi fi"  ${S}/configure.ac
	
	# fixing jack_midi_event
	einfo Patching ghostess.c
	sed -i 's/jack_default_midi_event_t/jack_midi_event_t/g' ${S}/src/ghostess.c
	sed -i 's/jack_midi_get_event_n/jack_midi_event_get/g' ${S}/src/ghostess.c
}

src_compile() {
	./autogen.sh
	#autoconf
	#libtoolize --copy --force
	econf `use_with jackmidi` --with-gtk2|| die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS
}
