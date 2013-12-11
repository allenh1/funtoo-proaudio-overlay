# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib flag-o-matic

MY_PV="${PV/./_}_release"
MY_P="JUCE-${MY_PV}"

DESCRIPTION="JUCE is an all-encompassing C++
class library for developing cross-platform applications."
HOMEPAGE=" http://www.juce.com"
SRC_URI="https://github.com/julianstorer/JUCE/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug xinerama flac vorbis opengl jucer demo multilib"

RDEPEND="=media-libs/freetype-2*
	>=media-libs/alsa-lib-0.9
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	>=x11-libs/libX11-1.0.1-r1
	multilib? ( app-emulation/emul-linux-x86-xlibs )"

DEPEND="${RDEPEND}
	app-arch/unzip
	x11-libs/libXinerama
	opengl? ( media-libs/freeglut )"

src_prepare() {
	epatch "${FILESDIR}/juce-1_53_release-Jucer.make.patch"
}

src_compile() {
	# demo fails with --as-needed
	filter-ldflags -Wl,--as-needed --as-needed

	local myconf=""
		use debug && myconf="CONFIG=Debug" || myconf="CONFIG=Release"

	if ! use xinerama; then
		sed -i -e "s:  #define JUCE_USE_XINERAMA 1://  #define JUCE_USE_XINERAMA 1:" juce_Config.h
	fi

	if use opengl; then
		sed -i -e "s://  #define JUCE_OPENGL 1:  #define JUCE_OPENGL 1:" juce_Config.h
	fi

	cd "${S}"/Builds/Linux
	# debug
	einfo "Running CFLAGS=${CFLAGS} make ${myconf} ..."
	emake ${myconf}

	if use demo; then
		cd "${S}/extras/JuceDemo/Builds/Linux"
		emake ${myconf}
	fi

	if use jucer; then
		cd "${S}/extras/the jucer/build/linux"
		emake ${myconf}
	fi

	# compile 32bit too on amd64/multilib
	if use multilib; then
		einfo "Compiling 32bit lib too..."

		# move 32bit lib out of the way
		mv "${S}/bin/libjuce.a" "${WORKDIR}/lib64juce.a"
		# clean bin dir
		rm -rf "${S}"/bin/*
		# and compile the lib again
		cd "${S}"/Builds/Linux
		emake clean
		CFLAGS="${CFLAGS} -m32"
		# debug
		einfo "Running CFLAGS=${CFLAGS} emake ${myconf} ..."
		emake ${myconf}
	fi
}

src_install() {
	if use multilib; then
		insinto /usr/lib32
		doins bin/libjuce.a
		insinto /usr/lib64
		newins "${WORKDIR}"/lib64juce.a libjuce.a
	else
		dolib bin/*.a
	fi
	use demo && dobin "extras/JuceDemo/Builds/Linux/build/JuceDemo"
	use jucer && dobin "extras/the jucer/build/linux/build/jucer"
	insinto /usr/share/doc/"${P}"
	doins docs/*.html docs/*.css docs/*.txt
	mv docs/images "${D}"/usr/share/doc/"${P}"
	insinto /usr/include/"${PN}"
	doins *.h
	# remove unneded sources
	rm -rf src/juce_appframework/audio/audio_file_formats/flac
	rm -rf src/juce_appframework/audio/audio_file_formats/oggvorbis
	rm -rf src/juce_appframework/gui/graphics/imaging/image_file_formats/jpglib
	rm -rf src/juce_appframework/gui/graphics/imaging/image_file_formats/pnglib
	cp -R src "${D}"/usr/include/"${PN}"
	# don't install .cpp files
	for i in `find "${D}"/usr/include/"${PN}"/src -name *.cpp`; do
		rm -f $i
	done
}
