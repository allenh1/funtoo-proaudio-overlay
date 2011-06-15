# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib subversion linux-info autotools

RESTRICT="nostrip mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/trunk/jack"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="3dnow altivec alsa celt coreaudio cpudetection doc debug examples mmx oss sse netjack freebob ieee1394 jackdmp"

RDEPEND="!jackdmp? ( 
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	celt? ( >=media-libs/celt-0.5.0 )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )
	netjack? ( media-libs/libsamplerate )
	!media-sound/jackdmp )"

DEPEND="${RDEPEND}
	!jackdmp? ( 
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )
	)"
PDEPEND="jackdmp? ( >=media-sound/jackdmp-9999-r1 )"

pkg_setup() {
	if use jackdmp; then
		ewarn "You have enabled the jackdmp useflag. This ebuild will just pull"
		ewarn "in jackdmp and will NOT compile and install ${PN}!"
		sleep 3
		return # no more to do
	fi
}

src_unpack() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi
	subversion_src_unpack

	cd "${S}"
	
	eautoreconf
}

src_compile() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi

	local myconf="--with-html-dir=/usr/share/doc/${PF}"

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use 3dnow && use mmx && use sse ; then
		einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
		myconf="${myconf} --enable-dynsimd"
		append-flags -mmmx -msse -m3dnow -O2
	fi
	
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	econf \
		$(use_enable ieee1394 firewire) \
		$(use_enable freebob) \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable mmx) \
		$(use_enable oss) \
		$(use_enable sse)  \
		--disable-dependency-tracking \
		--with-default-tmpdir=/dev/shm \
		${myconf} || die "configure failed"
	emake || die "compilation failed"
}

src_install() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi

	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS TODO README

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi
}
