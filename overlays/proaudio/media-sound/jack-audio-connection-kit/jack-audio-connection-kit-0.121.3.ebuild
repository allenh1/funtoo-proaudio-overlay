# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils eutils flag-o-matic

RESTRICT="mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.jackaudio.org/downloads/${P}.tar.gz
	http://nedko.arnaudov.name/soft/jack/dbus/${P}-dbus.patch"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="3dnow alsa altivec coreaudio cpudetection dbus debug doc examples freebob ieee1394 mmx oss pam sse"

RDEPEND=">=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	dbus? ( sys-apps/dbus )
	freebob? ( sys-libs/libfreebob )
	ieee1394? ( media-libs/libffado )
	media-libs/libsamplerate"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	pam? ( sys-auth/realtime-base )"

PATCHES=(
	"${FILESDIR}/${PN}-sparc-cpuinfo.patch"
	"${FILESDIR}/${PN}-freebsd.patch"
	"${FILESDIR}/${P}-respect-march.patch"
	"${DISTDIR}/${P}-dbus.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable altivec)
		$(use_enable alsa)
		$(use_enable coreaudio)
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable freebob)
		$(use_enable ieee1394 firewire)
		$(use_enable mmx)
		$(use_enable oss)
		$(use_enable sse)
		--disable-portaudio
		--with-html-dir=/usr/share/doc/${PF}
	)

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use 3dnow && use mmx && use sse ; then
		einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
		myeconfargs+=( --enable-dynsimd )
		append-flags -mmmx -msse -m3dnow -O2
	fi

	# Neither SSE nor MMX will be used if --enable-optimize is not given 
	if use mmx || use sse;  then
		myeconfargs+=( --enable-optimize )
	fi

	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi
}
