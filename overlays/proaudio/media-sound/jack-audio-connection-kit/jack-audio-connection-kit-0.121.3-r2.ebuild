# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# == THIS IS WORK IN PROGRESS ==
# [TODO]
# * sys-apps/dbus should be sys-apps/dbus[${MULTILIB_USEDEP}] when dbus
#   has been migrated to mulilib eclasses.
# * When libffado has been migrated to multilib eclasses
#   media-libs/libffado should be
#   media-libs/libffado[${MULTILIB_USEDEP}]
# [NOTE]
# The build won't fail if dbus or ffado is requested. It will just
# compile the 32-bit library without those features. I don't know how
# that will work out.

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
PYTHON_COMPAT=( python2_7 )
inherit autotools-multilib eutils flag-o-matic python-single-r1

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://www.jackaudio.org/downloads/${P}.tar.gz
	http://nedko.arnaudov.name/soft/jack/dbus/${P}-dbus.patch"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="3dnow alsa altivec coreaudio cpudetection dbus debug doc examples ieee1394 mmx oss pam sse"

RDEPEND="media-libs/libsamplerate[${MULTILIB_USEDEP}]
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	alsa? ( >=media-libs/alsa-lib-1.0.18[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus )
	ieee1394? ( media-libs/libffado )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r7
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	${PYTHON_DEPS}
	pam? ( sys-auth/realtime-base )"

PATCHES=(
	"${FILESDIR}/${PN}-sparc-cpuinfo.patch"
	"${FILESDIR}/${PN}-freebsd.patch"
	"${FILESDIR}/${P}-respect-march.patch"
	"${DISTDIR}/${P}-dbus.patch"
)

pkg_setup() {
	ewarn "You are about to install a very experimental ebuild!"
	ewarn "If you emerge this ebuild with USE='dbus' or USE='ieee1394'"
	ewarn "in conjunction with ABI_X86='32' and you are on amd64 you"
	ewarn "might experience some strange and yet unknown things"
	ewarn "happening."
	ewarn "You have been warned."
	python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable altivec)
		$(use_enable alsa)
		$(use_enable coreaudio)
		$(use_enable dbus)
		$(use_enable debug)
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

	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi

	python_fix_shebang "${ED}"
}
