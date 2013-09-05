# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils subversion

IUSE="alsa dbus debug doc float jack ladspa lash portaudio pulseaudio \
	readline sndfile"

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"
ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.6.5
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		>=media-libs/ladspa-cmt-1.15 )
	lash? ( virtual/liblash )
	portaudio? ( >=media-libs/portaudio-19_pre )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
	readline? ( sys-libs/readline )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS README THANKS TODO )

# Convenience function needed because the build system is not very
# standardized.
# Usage: fluid_use() <USE-flag> [flag name]
fluid_use() {
	[[ -z ${1} ]] && die "enable_arg(): too few arguments"
	if [[ ! -z ${2} ]]; then
		echo "-Denable-${2}=$(usex ${1} on off)"
	else
		echo "-Denable-${1}=$(usex ${1} on off)"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(fluid_use alsa)
		$(fluid_use dbus)
		$(fluid_use debug)
		$(fluid_use float floats)
		$(fluid_use jack)
		$(fluid_use ladspa)
		$(fluid_use lash)
		$(fluid_use portaudio)
		$(fluid_use pulseaudio)
		$(fluid_use readline)
		$(fluid_use sndfile libsndfile)
	)

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		cd "${BUILD_DIR}"
		emake doxygen
		HTML_DOCS=( "${BUILD_DIR}"/doc/api/html/ )
	fi

	cmake-utils_src_install
}
