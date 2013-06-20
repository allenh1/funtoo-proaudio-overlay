# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base scons-utils toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="An advanced command-line based metronome for JACK"
HOMEPAGE="http://das.nasophon.de/${PN}"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug osc rubberband"

RDEPEND="dev-libs/boost
	media-libs/libsamplerate
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# Respect our CXXFLAGS and use no deprecated stuff
PATCHES=( "${FILESDIR}/${P}-sconstruct.patch" )

DOCS=( NEWS README )
HTML_DOCS=( doc/manual.html )

src_configure() {
	export CXXFLAGS
	tc-export CXX

	myesconsargs=(
		$(use_scons debug DEBUG)
		$(use_scons osc OSC)
		$(use_scons rubberband RUBBERBAND)
		PREFIX="${EPREFIX}/usr"
		DESTDIR="${D}"
	)
}

src_compile() {
	escons
}

src_install() {
	escons install
	base_src_install_docs
}
