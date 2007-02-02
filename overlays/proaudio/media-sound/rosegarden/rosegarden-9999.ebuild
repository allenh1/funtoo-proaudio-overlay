# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit kde eutils subversion qt3 fetch-tools

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI=""

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/rosegarden/trunk/rosegarden"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="alsa jack dssi lirc debug"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.77 )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14
	dssi? ( >=media-libs/dssi-0.4 )
	lirc? ( >=app-misc/lirc-0.7 )
	>=dev-util/pkgconfig-0.15
	|| ( x11-libs/libX11 virtual/x11 )
	!media-sound/rosegarden-cvs
	!media-sound/rosegarden-svn
	>=media-libs/liblrdf-0.3
	>=sci-libs/fftw-3.0.0
	>=media-libs/liblo-0.7
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.2"

need-kde 3.1
need-qt 3

LANGS="ca cs cy de en_GB en es et fr it ja nl ru sv zh_CN"

S="${WORKDIR}/${PN}"
#S="${WORKDIR}/${MY_P}"
pkg_setup(){
	 if [ `usesflag "alsa"` == "0" ] && [ `usesflag "jack"` == "1" ];then
		eerror "if you disable alsa jack-support will also be disabled."
		eerror "This is not what you want --> enable alsa useflag" && die
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
		-DWANT_DEBUG=$(usesflag "debug") \
		-DWANT_FULLDBG=$(usesflag "debug") \
		-DWANT_SOUND=$(usesflag "alsa") \
		-DWANT_JACK=$(usesflag "jack") \
		-DWANT_DSSI=$(usesflag "dssi") \
		-DWANT_LIRC=$(usesflag "lirc") \
		|| die "cmake failed"
	use debug && CFLAGS="${CFLAGS} -ggdb3"
	
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" languages="$(echo $(echo "${LINGUAS} ${LANGS}" | fmt -w 1 | sort | uniq -d))" || die "install"
	dodoc ChangeLog-svn AUTHORS README TRANSLATORS
}
