# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit subversion autotools-utils

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com/"
ESVN_REPO_URI="https://subversion.assembla.com/svn/portaudio/portaudio/trunk"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="alsa +cxx debug jack oss static-libs"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

AUTOTOOLS_AUTORECONF="1"

DOCS=( README.txt )
HTML_DOCS=( index.html )

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output) \
		$(use_enable cxx) \
		$(use_enable static-libs static) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with oss)
	)
	autotools-utils_src_configure
}
