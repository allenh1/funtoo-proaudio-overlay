# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils
RESTRICT="mirror"

DESCRIPTION="Program to analyse a stereo audio signal."
HOMEPAGE="http://arvin.schnell-web.net/xanalyser/"
SRC_URI="http://arvin.schnell-web.net/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="media-libs/alsa-lib
	sci-libs/fftw
	x11-libs/libXpm
	x11-libs/motif"
RDEPEND="${DEPEND}"
