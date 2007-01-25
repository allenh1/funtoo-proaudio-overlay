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
IUSE="alsa jack"

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
		>=sys-devel/llvm-base-1.9"

pkg_setup() {
	if ! built_with_use sys-devel/llvm-base jit;then
		eerror "You need to compile sys-devel/llvm-base with the \"jit\""
		eerror "enabled."
		die
	fi
}

src_compile() {
	local myconf=""
	# those actually don't do anything at the moment, scons guesses
	use alsa \
		&& myconf="${myconf} ALSA=True" \
		|| myconf="${myconf} ALSA=False"
	use jack \
		&& myconf="${myconf} JACK=True" \
		|| myconf="${myconf} JACK=False"
		
	# broken currently, but lets keep IF it comes back
	# use dssi \
	# 	&& myconf="${myconf} DSSI=True" \
	#	|| myconf="${myconf} DSSI=False"
	#use ladspa \
	#	&& myconf="${myconf} LADSPA=True" \
	#	|| myconf="${myconf} LADSPA=False"
	
	scons \
		PREFIX=/usr \
		DESTDIR="${D}" \
		LLVMGCCPATH=/usr/bin \
		${myconf} \
		configure || die "configure failed"
	
	scons || die "Compilation failed"
}

src_install() {
	scons install || die
	dodoc CREDITS.txt
	cd src/pyzzub
	distutils_src_install
}

