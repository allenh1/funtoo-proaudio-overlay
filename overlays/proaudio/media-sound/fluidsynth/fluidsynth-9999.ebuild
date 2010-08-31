# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils subversion

IUSE="alsa dbus debug doc floats jack ladspa lash oss portaudio pulseaudio readline sndfile"

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.6.5
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		  >=media-libs/ladspa-cmt-1.15 )
	alsa? ( media-libs/alsa-lib
		lash? ( >=media-sound/lash-0.5 ) )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
	portaudio? ( >=media-libs/portaudio-19_pre )
	readline? ( sys-libs/readline )
	dbus? ( sys-apps/dbus )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use lash && ! use alsa; then
		ewarn "ALSA support is required for lash support to be enabled."
		ewarn "Continuing with lash support disabled."
	fi
}

src_configure() {
	local mycmakeargs=""

	if use alsa; then
		mycmakeargs="$(cmake-utils_use lash enable-lash)"
	else
		mycmakeargs="-Denable-lash=OFF"
	fi

	mycmakeargs+="
	$(cmake-utils_use floats enable-floats)
	$(cmake-utils_use ladspa enable-ladspa)
	$(cmake-utils_use debug enable-debug)
	$(cmake-utils_use sndfile enable-libsndfile)
	$(cmake-utils_use pulseaudio enable-pulsaudio)
	$(cmake-utils_use alsa enable-alsa)
	$(cmake-utils_use portaudio enable-portaudio)
	$(cmake-utils_use jack enable-jack)
	$(cmake-utils_use readline enable-readline)
	$(cmake-utils_use dbus enable-dbus)"

	cmake-utils_src_configure
}
