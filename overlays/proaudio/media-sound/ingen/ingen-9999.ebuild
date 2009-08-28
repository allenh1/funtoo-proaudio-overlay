# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils autotools

RESTRICT="mirror"
# lash currently not supported upstream
IUSE="midi ladspa osc gtk alsa lash"

DESCRIPTION="Ingen is a modular synthesizer using the Jack audio server and LV2 or LADSPA plugins."
HOMEPAGE="http://drobilla.net/software/ingen"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND="osc? ( >=media-libs/liblo-0.22 )
	>=media-libs/raul-9999
	>=dev-libs/redlandmm-9999
	lash? ( >=media-sound/lash-0.5.0 )
	midi? ( >=media-libs/alsa-lib-1.0.0 )
	>=dev-libs/libxml2-2.6
	>=dev-libs/glib-2.14.0
	>=dev-cpp/glibmm-2.14.0
	>=dev-libs/libsigc++-2.0
	gtk? ( >=dev-cpp/gtkmm-2.11.12
		>=dev-cpp/libgnomecanvasmm-2.6
		>=dev-cpp/libglademm-2.6.0
		>=net-libs/libsoup-2.4.0
		>=x11-libs/flowcanvas-9999 )
	ladspa? ( media-libs/ladspa-sdk )
	jack? ( >=media-sound/jack-audio-connection-kit-0.109.0 )
	>=media-libs/slv2-9999"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	dev-util/pkgconfig"

src_compile() {
	cd ${PN}

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure \
		--module-dir=/usr/$(get_libdir)/ingen \
		${myconf} || die

	./waf build ${MAKEOPTS} || die
}
src_install() {
	cd ${PN}
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS README THANKS NEWS TODO ChangeLog
}
