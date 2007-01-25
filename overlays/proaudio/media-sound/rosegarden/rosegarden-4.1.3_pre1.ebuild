# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"

inherit kde eutils flag-o-matic

MY_PV="${PV/_rc*/}"
MY_PV="${MY_PV/4./}"
MY_P="${PN}-${MY_PV/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="http://rosegarden.sourceforge.net/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa jack dssi lirc debug osc"

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
	media-libs/liblrdf
	osc? ( >=media-libs/liblo-0.7 )"
DEPEND="${RDEPEND}
	dev-util/scons"
need-kde 3.4

LANGS="ca cs cy de en_GB en es et fr it ja nl ru sv zh_CN"

#PATCHES="${FILESDIR}/rosegarden-4.1.2.3-kde.py.diff"

src_unpack() {
	unpack ${A}
	cd ${S}
	einfo "Patching: scons_admin/kde.py"
	sed -i 's|dir, destfile|"'${D}'" + dir,	destfile|g' scons_admin/kde.py
	# patch SConstruct to support ccache
	einfo "Patching: SConstruct to use ccache if possible"
	[ -n "${FEATURES}" -a -z "${FEATURES##*ccache*}" ] && sed -i -e'/\#\#\ Use\ this\ to\ set\ rpath/'i"## Useing ccache if possible\nif os.path.exists('/usr/lib/ccache/bin'):\n\tos.environ['PATH'] = '/usr/lib/ccache/bin:' + os.environ['PATH']\n\tenv['ENV']['CCACHE_DIR'] = os.environ['CCACHE_DIR']\n" SConstruct
	use osc || sed -i -e "98,100s|haveLiblo.*|haveLiblo = 0|" scons_admin/sound.py
}

src_compile() {
	[ -d "$QTDIR/etc/settings" ] && addwrite "$QTDIR/etc/settings"
	addpredict "$QTDIR/etc/settings"

	local myconf="kdeincludes=$(kde-config --prefix)/include prefix=${ROOT}/usr"
	use amd64 && myconf="${myconf} libsuffix=64"
	use lirc || myconf="${myconf} nolirc=1"
	use alsa || myconf="${myconf} noalsa=1"
	use jack || myconf="${myconf} nojack=1"
	use dssi || myconf="${myconf} nodssi=1"
	use debug &&  myconf="${myconf} debug=full"
	use debug && CFLAGS="${CFLAGS} -ggdb3"

	scons configure ${myconf} || die "configure failed"
	scons ${MAKEOPTS} || die "scons failed"
}

src_install() {
	scons install DESTDIR="${D}" languages="$(echo $(echo "${LINGUAS} ${LANGS}" | fmt -w 1 | sort | uniq -d))"
	dodoc AUTHORS README TRANSLATORS
}
