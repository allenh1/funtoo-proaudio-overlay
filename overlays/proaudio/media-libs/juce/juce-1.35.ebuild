# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-/_}"
MY_P="${MY_P/./_}"

DESCRIPTION="JUCE (Jules' Utility Class Extensions) is an all-encompassing C++
class library for developing cross-platform applications, especially UIs for
audio and video applications."
HOMEPAGE="http://www.rawmaterialsoftware.com/juce"
SRC_URI="http://www.rawmaterialsoftware.com/juce/downloads/${MY_P}.zip"
RESTRICT="nomirror"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug flac opengl vorbis"

DEPEND="=media-libs/freetype-2*
		virtual/x11
		>=media-libs/alsa-lib-0.9
		flac? ( media-libs/flac )
		opengl? ( virtual/opengl 
					media-libs/glut )
		vorbis? ( media-libs/libvorbis )"

pkg_setup() {
	if ! built_with_use sys-libs/glibc nptl; then
		eerror "JUCE needs POSIX threads in order to work."
		eerror "You will have to compile glibc with USE=\"nptl\"."
		die
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/"${P}"-gcc-4.1.patch
	epatch "${FILESDIR}"/"${P}"-vorbis_header.patch
}

src_compile() {
	local myconf
		use debug && myconf="CONFIG=Debug" || myconf="CONFIG=Release"
		
	if use opengl; then
		sed -i -e "s://  #define JUCE_OPENGL 1:  #define JUCE_OPENGL 1:" \
		juce_Config.h
	fi
	
	cd "${S}"/build/linux
	make ${myconf} || die "compiling the juce library failed"

	cd "${S}"/demo/build/linux
	make ${myconf} || die "compiling the juce demo failed"

	cd "${S}"/jucer/build/linux
	make ${myconf} || die "compiling jucer failed"
}

src_install() {
	dolib bin/*.a
	dobin demo/build/linux/build/jucedemo
	dobin jucer/build/linux/build/jucer
	insinto /usr/share/doc/"${P}"
	doins docs/*.html docs/*.css docs/*.txt
	mv docs/images "${D}"/usr/share/doc/"${P}"
}

