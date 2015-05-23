# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

HAVE_DBUS_PATCH=1

AUTOTOOLS_AUTORECONF=1

if [[ ${HAVE_DBUS_PATCH} ]]; then
	PYTHON_COMPAT=( python2_7 )
	inherit python-single-r1
fi

if [[ "${PV}" = "1.9999" ]]; then
	inherit git-r3
fi

inherit autotools-utils eutils flag-o-matic multilib-minimal

RESTRICT="mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

if [[ "${PV}" = "1.9999" ]]; then
	EGIT_REPO_URI="git://github.com/jackaudio/jack1.git"
	KEYWORDS=""
else
	SRC_URI="http://www.jackaudio.org/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

if [[ ${HAVE_DBUS_PATCH} ]]; then
	SRC_URI="${SRC_URI} http://nedko.arnaudov.name/soft/jack/dbus/${P}-dbus.patch"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

IUSE="alsa altivec celt coreaudio cpu_flags_x86_3dnow cpu_flags_x86_mmx
	cpu_flags_x86_sse cpudetection debug doc examples ieee1394 oss pam"

REQUIRED_USE="cpudetection? (
	cpu_flags_x86_3dnow
	cpu_flags_x86_mmx
	cpu_flags_x86_sse
)"

if [[ ${HAVE_DBUS_PATCH} ]]; then
	IUSE="${IUSE} dbus"
	REQUIRED_USE="dbus? ( ${PYTHON_REQUIRED_USE} )"
fi

# FIXME: automagic deps: readline, samplerate, sndfile, celt
CDEPEND="media-libs/libsamplerate[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	sys-libs/readline:0
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	celt? ( media-libs/celt:0[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
if [[ ${HAVE_DBUS_PATCH} ]]; then
	CDEPEND="${CDEPEND}
		dbus? (
			dev-libs/expat
			sys-apps/dbus
		)"
fi

DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	pam? ( sys-auth/realtime-base )"
if [[ ${HAVE_DBUS_PATCH} ]]; then
	RDEPEND="${RDEPEND}
		dbus? (
			${PYTHON_DEPS}
			dev-python/dbus-python[${PYTHON_USEDEP}]
		)"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-freebsd.patch
	"${FILESDIR}"/${PN}-sparc-cpuinfo.patch
)

[[ ${HAVE_DBUS_PATCH} ]] && PATCHES+=( "${DISTDIR}/${P}-dbus.patch" )

multilib_src_configure() {
	# --enable-mmx and --enable-sse only appends mmx and sse CFLAGS
	local myeconfargs=(
		--disable-mmx
		--disable-portaudio
		--disable-sse
		--with-html-dir=/usr/share/doc/${PF}
		$(use_enable alsa)
		$(use_enable altivec)
		$(use_enable coreaudio)
		$(use_enable cpudetection dynsimd)
		$(use_enable debug)
		$(use_enable ieee1394 firewire)
		$(use_enable oss)
	)

	[[ ${HAVE_DBUS_PATCH} ]] && myeconfargs+=( $(use_enable dbus) )

	if use cpudetection; then
		einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
		append-flags -mmmx -msse -m3dnow -O2
	fi

	multilib_is_native_abi && use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	autotools-utils_src_configure
}

multilib_src_compile() {
	autotools-utils_src_compile
}

multilib_src_install() {
	autotools-utils_src_install
}

multilib_src_install_all() {
	einstalldocs
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi

	[[ ${HAVE_DBUS_PATCH} ]] && use dbus && python_fix_shebang "${ED}"
}
