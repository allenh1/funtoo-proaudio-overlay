# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

inherit eutils cvs # autotools

DESCRIPTION="Media player primarily utilising ALSA"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="alsa audiofile doc esd flac gtk gtk2 jack mikmod nas nls ogg opengl oss vorbis
xosd"

ECVS_SERVER="alsaplayer.cvs.sourceforge.net:/cvsroot/alsaplayer"
ECVS_MODULE="alsaplayer"
ECVS_UP_OPTS="-D 20050129"
ECVS_CO_OPTS="-D 20050129"

S=${WORKDIR}/${ECVS_MODULE}

RDEPEND=">=dev-libs/glib-1.2.10
	>=media-libs/libsndfile-1.0.4
	alsa? ( media-libs/alsa-lib )
	audiofile? ( >=media-libs/audiofile-0.1.7 )
	esd? ( media-sound/esound )
	flac? ( media-libs/flac )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80.0 )
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	nas? ( media-libs/nas )
	ogg? ( media-libs/libogg )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )
	xosd? ( x11-libs/xosd )
	gtk? ( >=x11-libs/gtk+-1.2.6 )"

DEPEND="${RDEPEND}
	sys-apps/sed
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

src_unpack() {
	tar -xjpf ${FILESDIR}/${PN}-patches-2-9999.tar.bz2
	tar -xzpf ${FILESDIR}/${PN}-patches-3.tar.gz
	
	cvs_src_unpack

#	work, but do at debian patches don't work
#	cd ${S}
#	if use ppc; then
#		epatch ${FILESDIR}/alsaplayer-endian.patch
#	fi
	
	cd ${WORKDIR}
#	epatch "${FILESDIR}/${P}-join-null-thread.patch"
	epatch "${FILESDIR}/${P}-cxxflags.patch"
	
	cd ${S}

	# apply debian maintainer patches from
	# http://marc.theaimsgroup.com/?l=alsaplayer-devel&m=114878812719626&w=2
	for x in `ls --color=none ../patches`;do
		epatch "../patches/${x}" || die "debian patches failed"
	done
	# some splitted patches from
	# http://security.debian.org/pool/updates/main/a/alsaplayer/alsaplayer_0.99.76-0.3sarge1.diff.gz
	for x in `ls --color=none ../patches-3`;do
		epatch "../patches-3/${x}" || die "debian patches #3 failed"
	done
	
	#eautoreconf

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
	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}" install \
		|| die "make install failed"

	dodoc AUTHORS ChangeLog README TODO
	dodoc docs/wishlist.txt
}
