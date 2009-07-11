# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit cmake-utils eutils exteutils git kde qt3 

DESCRIPTION="OpenOctave MIDI sequencer"
HOMEPAGE="http://www.openoctave.org"
SRC_URI=""

EGIT_REPO_URI="git://68.150.160.199:9418/var/git/openoctave.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug lilypond export kde gnome"

RDEPEND="lilypond? ( media-sound/lilypond
		|| ( kde? ( kde-base/kghostview ) gnome? ( app-text/evince ) app-text/ggv ) )
	export? ( || ( kde-base/kdialog kde-base/kdebase )
			dev-perl/XML-Twig
			media-libs/libsndfile )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/liblrdf-0.3
	>=sci-libs/fftw-3.0.0
	>=media-libs/liblo-0.7
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=dev-util/cmake-2.4.2"

need-kde 3.1
need-qt 3

S="${WORKDIR}/${PN}"

pkg_setup(){
	if ! use export && \
		! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
		has_any-pkg "kde-base/kdialog kde-base/kdebase" ) ;then
		ewarn "you won't be able to use the project-package-manager"
		ewarn "please remerge with USE=\"export\"" && sleep 3
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/ggv kde-base/kghostview app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi
}

src_unpack() {
	git_src_unpack
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
