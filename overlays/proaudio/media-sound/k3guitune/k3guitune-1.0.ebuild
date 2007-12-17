# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde eutils

DESCRIPTION="A program for KDE that lets you tune musical instruments."
HOMEPAGE="http://home.planet.nl/~lamer024/k3guitune.html"
SRC_URI="http://home.planet.nl/~lamer024/files/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="alsa arts jack oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( media-sound/jack-audio-connection-kit
				media-libs/bio2jack )
		=sci-libs/fftw-3*"
DEPEND="${RDEPEND}"

need-kde 3

src_unpack() {
	kde_src_unpack
	use arts || epatch "${FILESDIR}/${P}-configure.patch"
}

src_compile() {
	local myconf="$(use_enable alsa) $(use_enable arts)
	              $(use_enable oss) $(use_enable jack)"

	kde_src_compile
}
