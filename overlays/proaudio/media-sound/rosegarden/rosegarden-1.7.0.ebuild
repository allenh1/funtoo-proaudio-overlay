# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rosegarden/rosegarden-1.6.1-r1.ebuild,v 1.2 2008/04/23 17:21:31 flameeyes Exp $

inherit exteutils kde-functions cmake-utils

MY_PV="${PV/_rc*/}"
#MY_PV="${MY_PV/4./}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/rosegarden/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa debug jack dssi lirc lilypond export kde gnome"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0
		jack? ( >=media-sound/jack-audio-connection-kit-0.77 )
	)
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	dssi? ( >=media-libs/dssi-0.4 )
	lirc? ( >=app-misc/lirc-0.7 )
	>=media-libs/liblrdf-0.3
	>=sci-libs/fftw-3.0.0
	|| ( x11-libs/libX11 virtual/x11 )
	lilypond? ( media-sound/lilypond
		|| ( kde? ( kde-base/kghostview ) gnome? ( app-text/evince ) app-text/ggv ) )
	export? ( || ( kde-base/kdialog kde-base/kdebase )
			dev-perl/XML-Twig
			media-libs/libsndfile )
	x11-libs/libXtst
	>=media-libs/liblo-0.7"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=dev-util/cmake-2.4.2"

need-kde 3.5

pkg_setup() {
	if ! use alsa  && use jack ;then
		eerror "if you disable alsa jack-support will also be disabled."
		eerror "This is not what you want --> enable alsa useflag" 
		die "jack support needs alsa USE flag to be set"
	fi
	if ! use export && \
		! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
		has_any-pkg "kde-base/kdialog kde-base/kdebase" ) ;then
		ewarn "you won't be able to use the rosegarden-project-package-manager"
		ewarn "please remerge with USE=\"export\"" && sleep 3
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/ggv kde-base/kghostview app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi

	if use alsa && ! built_with_use --missing true media-libs/alsa-lib midi; then
		eerror ""
		eerror "To be able to build Rosegarden with ALSA support you need"
		eerror "to have built media-libs/alsa-lib with midi USE flag."
		die "Missing midi USE flag on media-libs/alsa-lib"
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/rosegarden-1.6.1-asneeded.patch" \
		"${FILESDIR}/rosegarden-1.6.1.desktop.diff"
}

src_compile() {
	tc-export CC CXX LD

	# cmake is stupid, very very stupid.
	esed_check -i -e 's:CMAKE_CXX_FLAGS_\(RELEASE\|RELWITHDEBINFO\|DEBUG\).*".*"):CMAKE_CXX_FLAGS_\1 "'"${CXXFLAGS}"'"):' \
		CMakeLists.txt || die "unable to sanitise CXXFLAGS"

	mycmakeargs="$(cmake-utils_use_want alsa SOUND)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want dssi DSSI)
		$(cmake-utils_use_want lirc LIRC)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want debug FULLDBG)"

	use debug && CFLAGS="${CFLAGS} -ggdb3"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS README TRANSLATORS
}
