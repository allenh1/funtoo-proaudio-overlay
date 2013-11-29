# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# == THIS IS WORK IN PROGRESS ==
# [TODO]
# * When libffado has been migrated to multilib eclasses
#   media-libs/libffado should be
#   media-libs/libffado[${MULTILIB_USEDEP}]
# * More testing is definitely needed because this revision incorporates
#   more changes to the 1.9999 ebuild than just multilib!
# [NOTE]
# The build won't fail if dbus or ffado is requested. It will just
# compile the 32-bit library without those features. I don't know how
# that will work out.

# The build system fails with out of source builds. The sources thus
# need to be copied so that an in source build can be done.

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
inherit autotools-utils eutils flag-o-matic git-2 multilib-minimal

RESTRICT="mirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

EGIT_REPO_URI="git://github.com/jackaudio/jack1.git"
EGIT_HAS_SUBMODULES="example-clients"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="3dnow altivec alsa celt coreaudio cpudetection doc debug examples mmx oss sse netjack ieee1394"

RDEPEND=">=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	celt? ( media-libs/celt[${MULTILIB_USEDEP}] )
	alsa? ( >=media-libs/alsa-lib-0.9.1[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado )
	netjack? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r7
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )"

pkg_setup() {
	ewarn "You are about to install a very experimental ebuild!"
	ewarn "If you emerge this ebuild with USE='ieee1394' in conjunction"
	ewarn "with ABI_X86='32' and you are on amd64 you might experience"
	ewarn "some strange and yet unknown things happening."
	ewarn "You have been warned."
}

src_prepare() {
	autotools-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		--with-default-tmpdir=/dev/shm
		--with-html-dir=/usr/share/doc/${PF}
		$(use_enable alsa)
		$(use_enable altivec)
		$(use_enable coreaudio)
		$(use_enable debug)
		$(use_enable ieee1394 firewire)
		$(use_enable oss)
		$(use_enable sse)
	)

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use 3dnow && use mmx && use sse ; then
		einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
		myeconfargs=( --enable-dynsimd )
		append-flags -mmmx -msse -m3dnow -O2
	fi

	multilib_is_native_abi && use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_configure
}

multilib_src_compile() {
	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_compile
}

multilib_src_install() {
	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_install
}

multilib_src_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	fi
}
