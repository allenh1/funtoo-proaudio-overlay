# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="buzz compatibility lib for aldrin"
HOMEPAGE="http://trac.zeitherrschaft.org/aldrin"
SRC_URI="mirror://sourceforge/aldrin/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
		if ! built_with_use sys-devel/llvm-base jit;then
			eerror "You need to compile sys-devel/llvm-base with the \"jit\""
			eerror "enabled."
			die
		else
			ewarn "Note: LLVM is a bleeding edge bleeding edge compiler"
			ewarn "suite that offers very optimized code."
			ewarn "It takes a while to compile! You can also choose"
			ewarn "libzzub's GCC wrapper with USE=\"-llvm\"."
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

