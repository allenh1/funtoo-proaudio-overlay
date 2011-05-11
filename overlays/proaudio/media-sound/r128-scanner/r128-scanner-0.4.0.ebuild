# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

MY_PN="libebur128"
MY_PV="${PV}-Source"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A tool for implementing the EBU R128 loudness standard, with ReplayGain support"
HOMEPAGE="http://www-public.tu-bs.de:8080/~y0035293/libebur128.html"
SRC_URI="http://www-public.tu-bs.de:8080/~y0035293/${MY_P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~x86"

IUSE="ffmpeg mp3 musepack sndfile"

DEPEND="!media-sound/libebur128
	ffmpeg? ( virtual/ffmpeg )
	mp3? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	sndfile? ( media-libs/libsndfile )
	media-libs/taglib
	"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	cd ${CMAKE_BUILD_DIR}
	if use ffmpeg ; then
		dolib.so libinput_ffmpeg.so
	fi

	if use mp3 ; then
		dolib.so libinput_mpg123.so
	fi

	if use musepack ; then
		dolib.so libinput_musepack.so
	fi

	if use sndfile ; then
		dolib.so libinput_sndfile.so
	fi

	dobin ${PN}
}
