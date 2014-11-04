# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit cmake-utils multilib subversion

DESCRIPTION="A SoundFont instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
ESVN_REPO_URI="https://swami.svn.sourceforge.net/svnroot/swami/trunk/swami"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug fftw fluidsynth"

RDEPEND=">=dev-libs/libinstpatch-1.0.0
	>=gnome-base/libglade-2.6.0
	>=gnome-base/libgnomecanvas-2.30.3
	>=gnome-base/librsvg-2.8:2
	>=media-libs/libsndfile-1.0.0
	>=x11-libs/gtk+-2.20:2
	fftw? ( >=sci-libs/fftw-3.1:3.0 )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local mycmakeargs=(
		-DPLUGINS_DIR="${PREFIX}/usr/$(get_libdir)/swami" # multilib-strict
		$(cmake-utils_use fftw enable-fftw)
		$(cmake-utils_use fluidsynth enable-fluidsynth)
	)
	cmake-utils_src_configure
}
