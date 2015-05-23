# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils git-r3

IUSE="alsa dbus debug doc examples float ipv6 jack ladspa lash portaudio
	pulseaudio readline sndfile"

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code-git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-libs/glib:2
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? (
		media-libs/ladspa-sdk
		media-libs/ladspa-cmt
	)
	lash? ( virtual/liblash )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	readline? ( sys-libs/readline:0 )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${S}/fluidsynth"

src_configure() {
	local mycmakeargs=(
		-Denable-aufile=ON
		-Denable-ladcca=OFF
		-Denable-midishare=OFF
		$(cmake-utils_use alsa enable-alsa)
		$(cmake-utils_use dbus enable-dbus)
		$(cmake-utils_use debug enable-debug)
		$(cmake-utils_use float enable-floats)
		$(cmake-utils_use ipv6 enable-ipv6)
		$(cmake-utils_use jack enable-jack)
		$(cmake-utils_use ladspa enable-ladspa)
		$(cmake-utils_use lash enable-lash)
		$(cmake-utils_use portaudio enable-portaudio)
		$(cmake-utils_use pulseaudio enable-pulseaudio)
		$(cmake-utils_use readline enable-readline)
		$(cmake-utils_use sndfile enable-libsndfile)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doxygen
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/api/html/* )
	cmake-utils_src_install

	docinto pdf
	dodoc doc/*.pdf

	if use examples; then
		docinto examples
		dodoc doc/*.c
	fi
}
