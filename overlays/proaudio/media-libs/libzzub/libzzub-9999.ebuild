# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="buzz compatibility lib for aldrin"
HOMEPAGE="http://trac.zeitherrschaft.org/aldrin"

SRC_URI=""
ESVN_REPO_URI="http://svn.zeitherrschaft.org/zzub/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa jack llvm"

DEPEND="${RDEPEND}
		dev-util/scons"
RDEPEND=">=dev-lang/python-2.4
		>=dev-python/wxpython-2.6
		media-libs/libsndfile
		dev-python/ctypes
		jack? ( media-sound/jack-audio-connection-kit  )
		alsa? ( media-libs/alsa-lib )
		sys-libs/zlib
		media-libs/flac
		llvm? ( >=sys-devel/llvm-base-1.9 )"

pkg_setup() {
	if use llvm; then
		ewarn "Note: LLVM is a bleeding edge bleeding edge compiler suite that"
		ewarn "offers very optimized code. It takes a while to compile!"
		ewarn "llvm-base and llvm-gcc can be found in the proaudio-dev overlay."
		ewarn ""
		ewarn "You can also choose libzzub's GCC wrapper with USE=\"-llvm\"."

		if ! built_with_use sys-devel/llvm-base jit;then
			eerror "You need to compile sys-devel/llvm-base with the \"jit\""
			eerror "enabled."
			die
		fi
	fi
}

src_compile() {
	local myconf=""

	use llvm \
		&& myconf="${myconf} LUNARTARGET=llvm LLVMGCCPATH=/usr/bin" \
		|| myconf="${myconf} LUNARTARGET=gcc"

	scons \
		PREFIX=/usr \
		DESTDIR="${D}" \
		${myconf} \
		configure || die "configure failed"

	scons || die "compilation failed"
}

src_install() {
	scons install || die
	dodoc CREDITS.txt
	cd src/pyzzub
	distutils_src_install
}

