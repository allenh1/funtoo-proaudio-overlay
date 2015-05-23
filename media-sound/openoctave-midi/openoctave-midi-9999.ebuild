# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils git-2

DESCRIPTION="OpenOctave MIDI sequencer"
HOMEPAGE="http://www.openoctave.org"
EGIT_REPO_URI="git://git.openoctave.org/oom.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug lilypond export kde gnome"

RDEPEND="lilypond? ( media-sound/lilypond
		|| ( kde? ( kde-base/kghostview ) gnome? ( app-text/evince ) ) )
	export? ( || ( kde-base/kdialog kde-base/kdebase )
			dev-perl/XML-Twig
			media-libs/libsndfile )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/liblrdf-0.3
	>=media-sound/linuxsampler-9999
	>=sci-libs/fftw-3.0.0
	>=media-libs/liblo-0.7
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/cmake-2.4.2"

S="${WORKDIR}/${PN}"

pkg_setup(){
	if ! use export && \
		! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
		has_any-pkg "kde-base/kdialog kde-base/kdebase" ) ;then
		ewarn "you won't be able to use the project-package-manager"
		ewarn "please remerge with USE=\"export\"" && sleep 3
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "kde-base/kghostview app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi
}

src_unpack() {
	git-2_src_unpack
}

src_compile() {
	local mycmakeargs="
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable debug FULLDBG)"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	cd "${S}"
	dodoc AUTHORS README TRANSLATORS
}
