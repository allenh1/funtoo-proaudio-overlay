# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-/_}"
MY_P="${MY_P/./_}"

DESCRIPTION="JUCE (Jules' Utility Class Extensions) is an all-encompassing C++
class library for developing cross-platform applications, especially UIs for
audio and video applications."
HOMEPAGE=" http://www.rawmaterialsoftware.com/juce"
#SRC_URI="http://www.rawmaterialsoftware.com/juce/downloads/${MY_P}.zip "
SRC_URI="http://downloads.sourceforge.net/juce/${MY_P}.zip "
RESTRICT="mirror"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug xinerama flac vorbis opengl"

RDEPEND="=media-libs/freetype-2*
	>=media-libs/alsa-lib-0.9
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	|| ( >=x11-libs/libX11-1.0.1-r1 virtual/x11 )"
DEPEND="${RDEPEND}
	app-arch/unzip
	|| ( ( 	x11-proto/xineramaproto
			x11-proto/xextproto
			x11-proto/xproto )
		virtual/x11 )
	opengl? ( virtual/opengl || ( media-libs/freeglut media-libs/glut ) )"

pkg_setup() {
	if has_version "<= sys-libs/glibc-2.5"; then
		if ! built_with_use sys-libs/glibc nptl ; then
			eerror "JUCE needs POSIX threads in order to work."
			eerror "You will have to compile glibc with USE=\"nptl\"."
			die
		fi
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/"${PN}"-1.31-vorbis_header.patch
}

src_compile() {
	local myconf
		use debug && myconf="CONFIG=Debug" || myconf="CONFIG=Release"

	if ! use xinerama; then
		sed -i -e "s:  #define JUCE_USE_XINERAMA 1://  #define JUCE_USE_XINERAMA 1:" juce_Config.h
	fi

	if use opengl; then
		sed -i -e "s://  #define JUCE_OPENGL 1:  #define JUCE_OPENGL 1:" juce_Config.h
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
	insinto /usr/include/"${PN}"
	doins *.h
	cp -R src "${D}"/usr/include/"${PN}"
	for i in `find ${D}/usr/include/${PN}/src -name *.cpp`; do
		rm -f $i
	done
}

