# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit kde eutils subversion qt3 exteutils

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI=""

ESVN_REPO_URI="https://rosegarden.svn.sourceforge.net/svnroot/rosegarden/trunk/rosegarden"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa jack dssi lirc debug lilypond export kde gnome"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0 )
	lilypond? ( media-sound/lilypond
		|| ( kde? ( kde-base/kghostview ) gnome? ( app-text/evince ) app-text/ggv ) )
	export? ( kde-base/kdialog
			dev-perl/XML-Twig
			media-libs/libsndfile )
	jack? ( >=media-sound/jack-audio-connection-kit-0.77 )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	dssi? ( >=media-libs/dssi-0.4 )
	lirc? ( >=app-misc/lirc-0.7 )
	|| ( x11-libs/libX11 virtual/x11 )
	!media-sound/rosegarden-cvs
	!media-sound/rosegarden-svn
	>=media-libs/liblrdf-0.3
	>=sci-libs/fftw-3.0.0
	>=media-libs/liblo-0.7
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=dev-util/cmake-2.4.2"

need-kde 3.1
need-qt 3

LANGS="ca cs cy de en_GB en es et fr it ja nl ru sv zh_CN"

S="${WORKDIR}/${PN}"
#S="${WORKDIR}/${MY_P}"
pkg_setup(){
	if ! use alsa  && use jack ;then
		eerror "if you disable alsa jack-support will also be disabled."
		eerror "This is not what you want --> enable alsa useflag" && die
	fi
	if ! use export && ! has_all-pkg "kde-base/kdialog media-libs/libsndfile dev-perl/XML-Twig"  ;then
		ewarn "you won't be able to use the rosegarden-project-package-manager"
		ewarn "please remerge with USE=\"export\"" && sleep 3
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/ggv kde-base/kghostview app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi
}

src_unpack() {
	subversion_fetch
	cd ${S}
	svn log -r HEAD:7144 ${ESVN_REPO_URI} > ChangeLog-svn &
}

src_compile() {
	local myconf=""
	cmake . -DCMAKE_INSTALL_PREFIX=/usr \
		-DWANT_DEBUG="$(! use debug; echo "$?")" \
		-DWANT_FULLDBG="$(! use debug; echo "$?")" \
		-DWANT_SOUND="$(! use alsa; echo "$?")" \
		-DWANT_JACK="$(! use jack; echo "$?")" \
		-DWANT_DSSI="$(! use dssi; echo "$?")" \
		-DWANT_LIRC="$(! use lirc; echo "$?")" \
		|| die "cmake failed"
	use debug && CFLAGS="${CFLAGS} -ggdb3"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" languages="$(echo $(echo "${LINGUAS} ${LANGS}" | fmt -w 1 | sort | uniq -d))" || die "install"
	dodoc ChangeLog-svn AUTHORS README TRANSLATORS
}
