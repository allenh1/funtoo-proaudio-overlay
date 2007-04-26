# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit unipatch-001 eutils subversion # autotools

DESCRIPTION="Media player primarily utilising ALSA"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa audiofile doc esd flac gtk gtk2 jack mikmod nas nls ogg opengl oss vorbis
xosd"

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/alsaplayer/trunk/alsaplayer"

S=${WORKDIR}/${PN}

RDEPEND="media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	audiofile? ( media-libs/audiofile )
	esd? ( media-sound/esound )
	flac? ( media-libs/flac )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80.0 )
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	nas? ( media-libs/nas )
	ogg? ( media-libs/libogg )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )
	xosd? ( x11-libs/xosd )
	gtk? ( >=x11-libs/gtk+-1.2 )
	gtk2? ( >=x11-libs/gtk+-2.6 )"

DEPEND="${RDEPEND}
	sys-apps/sed
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

src_unpack() {
	subversion_src_unpack

	cd ${S}
	
	UNIPATCH_LIST="${FILESDIR}/${P}-cxxflags.patch"
	unipatch
	
	./bootstrap || die "bootstrap failed"

}

src_compile() {
	export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include"

	use xosd ||
		export ac_cv_lib_xosd_xosd_create="no"

	use doc ||
		export ac_cv_prog_HAVE_DOXYGEN="false"

	if use ogg && use flac; then
		myconf="${myconf} --enable-oggflac"
	fi

	econf \
		$(use_enable audiofile) \
		$(use_enable esd) \
		$(use_enable flac) \
		$(use_enable jack) \
		$(use_enable mikmod) \
		$(use_enable nas) \
		$(use_enable opengl) \
		$(use_enable oss) \
		$(use_enable nls) \
		$(use_enable sparc) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable gtk) \
		$(use_enable gtk2) \
		${myconf} \
		--disable-sgi --disable-dependency-tracking \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PN}" install \
		|| die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
	dodoc docs/wishlist.txt
}
