# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils exteutils git-2  jackmidi
#patcher toolchain-funcs jackmidi
RESTRICT="mirror"

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/zynaddsubfx-presets-0.1.tar.bz2"

EGIT_REPO_URI="git://git.code.sf.net/p/zynaddsubfx/code"
EGIT_PROJECT="${PN}"

EGIT_REPO_URI_INSTRUMENTS="git://git.code.sf.net/p/zynaddsubfx/instruments"
EGIT_PROJECT_INSTRUMENTS="${PN}-instruments"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="oss alsa jack jackmidi lash portaudio"

DEPEND=">=x11-libs/fltk-1.1.2
	=sci-libs/fftw-3*
	jackmidi? ( >=media-sound/jack-audio-connection-kit-0.100.0-r3 )
	!jackmidi? ( media-sound/jack-audio-connection-kit )
	>=dev-libs/mini-xml-2.2.1
	lash? ( virtual/liblash )
	portaudio? ( media-libs/portaudio )"

RDEPEND="!media-libs/zynaddsubfx-banks
	!media-sound/zynaddsubfx-cvs"

#pkg_setup() {
	# jackmidi.eclass
#	use jackmidi && need_jackmidi
#}

src_unpack() {
	git-2_src_unpack

	unset EGIT_BRANCH EGIT_COMMIT
	EGIT_SOURCEDIR="${S}"/instruments \
		EGIT_REPO_URI="${EGIT_REPO_URI_INSTRUMENTS}" \
		EGIT_PROJECT="${EGIT_PROJECT_INSTRUMENTS}" \
		git-2_src_unpack

	unpack "zynaddsubfx-presets-0.1.tar.bz2"

	# fix the desktop files
	esed_check -i -e 's:Application;AudioVideo;:AudioVideo;Audio;:' "${S}"/zynaddsubfx-alsa.desktop
	esed_check -i -e 's:Application;AudioVideo;:AudioVideo;Audio;:' "${S}"/zynaddsubfx-jack.desktop
}

src_configure() {
	# the last used flag is used as default input and output
	# it doesn't work, comment everything
#	INPUT="null"
#	OUTPUT="null"
#	if use oss ; then
#		WOSS="1"
#		INPUT="oss"
#		OUTPUT="oss"
#	else
#		WOSS="0"
#	fi
#	if use portaudio ; then
#		WPA="1"
#		OUTPUT="portaudio"
#	else
#		WPA="0"
#	fi
#	if use alsa ; then
#		WALSA="1"
#		INPUT="alsa"
#		OUTPUT="alsa"
#	else
#		WALSA="0"
#	fi
#	if use jack ; then
#		WJACK="1"
#		INPUT="jack"
#		OUTPUT="jack"
#	else
#		WJACK="0"
#	fi

#	local mycmakeargs=(
#		-OssEnable="${WOSS}"
#		-PaEnable="${WPA}"
#		-AlsaEnable="${WALSA}"
#		-JackEnable="${WJACK}"
#		-DefaultInput="${INPUT}"
#		-DefaultOuput="${OUTPUT}"
#		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "${S}"/ExternalPrograms/Spliter
	emake
	cd "${S}"/ExternalPrograms/Controller
	emake
}

src_install() {
	cmake-utils_src_install

	# -------- install examples presets
##	[ "${#MY_PN}" == "0" ] && MY_PN="${PN}"
	insinto /usr/share/${PN}/presets
	doins "${WORKDIR}/presets/"*
	insinto /usr/share/${PN}/examples
	doins "${WORKDIR}/examples/"*
	doins "${S}/instruments/examples/"*
	# --------
}

pkg_postinst() {
	einfo "Banks are now provided with this package"
	einfo "To get some nice sounding parameters emerge zynaddsubfx-extras"
}
