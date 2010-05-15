# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI="2"

inherit exteutils subversion autotools

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI=""

ESVN_REPO_URI="https://rosegarden.svn.sourceforge.net/svnroot/rosegarden/trunk/rosegarden"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa jack dssi lirc debug lilypond export kde gnome"

RDEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui ) >=x11-libs/qt-4.3:4 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	lilypond? ( >=media-sound/lilypond-2.6.0
		|| ( kde? ( kde-base/okular ) gnome? ( app-text/evince ) app-text/acroread ) )
	export? ( || ( kde-base/kdialog kde-base/kdebase ) dev-perl/XML-Twig >=media-libs/libsndfile-1.0.16 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.109 )
	>=media-libs/ladspa-sdk-1.1
	>=media-libs/ladspa-cmt-1.14
	dssi? ( >=media-libs/dssi-0.9 )
	lirc? ( >=app-misc/lirc-0.8 )
	|| ( x11-libs/libX11 virtual/x11 )
	media-libs/liblrdf
	sci-libs/fftw:3.0
	>=media-libs/liblo-0.23
	>=media-libs/libsamplerate-0.1.4
	x11-misc/makedepend
	x11-libs/libXtst"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.1
	>=dev-util/pkgconfig-0.22"

LANGS="ca cs cy de en_GB en es et fr it ja nl ru sv zh_CN"

pkg_setup(){
	if ! use alsa  && use jack ;then
		eerror "if you disable alsa jack-support will also be disabled."
		eerror "This is not what you want --> enable alsa useflag" && die
	fi
	if ! use export && \
		! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
		has_any-pkg "kde-base/kdialog kde-base/kdebase" ) ;then
		ewarn "you won't be able to use the rosegarden-project-package-manager"
		ewarn "please remerge with USE=\"export\"" && sleep 3
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/acroread kde-base/okular app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi
}

src_prepare() {
	svn log -r HEAD:7144 ${ESVN_REPO_URI} > ChangeLog-svn &
	eaclocal -I . && eautoconf
}

src_configure() {
	econf	--with-qtdir=/usr/ --with-qtlibdir=/usr/$(get_libdir)/qt4
}

src_compile() {
	use debug && CFLAGS="${CFLAGS} -ggdb3"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" languages="$(echo $(echo "${LINGUAS} ${LANGS}" | fmt -w 1 | sort | uniq -d))" || die "install"
	dodoc ChangeLog-svn AUTHORS README
}
