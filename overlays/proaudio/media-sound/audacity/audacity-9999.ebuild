# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest

inherit eutils autotools wxwidgets cvs

IUSE="flac ladspa libsamplerate mp3 unicode vamp vorbis"

MY_P="${PN}-src-${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://audacity.sourceforge.net/"

ECVS_SERVER="audacity.cvs.sourceforge.net:/cvsroot/audacity"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RESTRICT="test"

DEPEND=">=x11-libs/wxGTK-2.6
	>=app-arch/zip-2.3
	dev-libs/expat
	>=media-libs/libsndfile-1.0.0
	>=media-libs/libsoundtouch-1.3.1
	vorbis? ( >=media-libs/libvorbis-1.0 )
	mp3? ( >=media-libs/libmad-0.14.2b
		media-libs/libid3tag )
	flac? ( media-libs/flac )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	vamp? ( dev-libs/vamp-plugin-sdk )"
RDEPEND="${DEPEND}
	mp3? ( >=media-sound/lame-3.70 )"

S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack	

	cd "${S}"
	#epatch "${FILESDIR}/${P}-gentoo.patch"
	#epatch "${FILESDIR}/${P}+flac-1.1.3.patch"

	#eautoreconf || die
}

src_compile() {
	local myconf

	if has_version "=x11-libs/wxGTK-2.8*"; then
		myconf="--with-wx-version=2.8"
	else
		myconf="--with-wx-version=2.6"
	fi

	myconf="${myconf} --with-libsndfile=system"
	myconf="${myconf} --with-libexpat=system"
	myconf="${myconf} --with-libsoundtouch=system"

	if use libsamplerate ; then
		myconf="${myconf} --with-libsamplerate=system --without-libresample"
	else
		myconf="${myconf} --without-libsamplerate" # --with-libresample=local
	fi

	econf \
		$(use_enable unicode) \
		$(use_enable ladspa) \
		$(use_enable vamp) \
		$(use_with vorbis vorbis system) \
		$(use_with mp3 libmad system) \
		$(use_with mp3 id3tag system) \
		$(use_with flac flac system) \
		${myconf} || die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	# Remove bad doc install
	rm -rf "${D}"/usr/share/doc

	# Install our docs
	dodoc README.txt

	insinto /usr/share/audacity/
	newins images/AudacityLogo48x48.xpm audacity.xpm
}
