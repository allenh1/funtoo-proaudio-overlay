# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base git multilib autotools

DESCRIPTION="Calf is a set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf.sf.net/"
EGIT_REPO_URI="git://repo.or.cz/calf.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug dssi +jack +lash +lv2 -ladspa"

RDEPEND="dev-libs/glib:2
	dev-libs/expat
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	dssi? ( media-libs/dssi )
	lash? ( media-sound/lash )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( || ( media-libs/lv2core >=media-libs/lv2-1.0.0 ) )
	ladspa? ( media-libs/ladspa-sdk )"
DEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# CXXFLAGS contains -O3
	sed -i -e "s/-O3//" configure.ac || die
}

src_configure() {
	NOCONFIGURE=1 ./autogen.sh
	econf --with-ladspa-dir="/usr/$(get_libdir)/ladspa" \
		--with-dssi-dir="/usr/$(get_libdir)/dssi" \
		--with-lv2-dir="/usr/$(get_libdir)/lv2" \
		$(use_enable debug) \
		$(use_with ladspa) \
		$(use_with lv2) \
		|| die
}

src_install() {
	# work around sandbox violation of
	# /etc/gconf/gconf.xml.defaults/.testing.writeability due to gconf makefile
	# schema install
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
	make DESTDIR="${D}" install || die
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
}
