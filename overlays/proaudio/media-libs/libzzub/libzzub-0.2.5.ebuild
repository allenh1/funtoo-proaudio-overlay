# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils distutils

DESCRIPTION="buzz compatibility lib for aldrin"
HOMEPAGE="http://code.google.com/p/aldrin-sequencer/"
SRC_URI="http://aldrin-sequencer.googlecode.com/files/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa jack llvm"

DEPEND="${RDEPEND}
		dev-util/scons"
RDEPEND=">=dev-lang/python-2.5
		>=dev-python/wxpython-2.6
		media-libs/libsndfile
		jack? ( media-sound/jack-audio-connection-kit  )
		alsa? ( media-libs/alsa-lib )
		sys-libs/zlib
		media-libs/flac
		llvm? ( >=sys-devel/llvm-base-1.9[jit] )"

pkg_setup() {
	if use llvm; then
		ewarn "Note: LLVM is a bleeding edge bleeding edge compiler suite that"
		ewarn "offers very optimized code. It takes a while to compile!"
		ewarn "llvm-base and llvm-gcc can be found in the proaudio-dev overlay."
		ewarn ""
		ewarn "You can also choose libzzub's GCC wrapper with USE=\"-llvm\"."
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
