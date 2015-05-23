# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="An application to play back audio files at a different speed or pitch"
HOMEPAGE="http://29a.ch/${PN}/"
SRC_URI="http://29a.ch/${PN}/${P}.tar.gz"
RESTRICT="mirror"

KEYWORDS="~amd64"

IUSE=""

LICENSE="GPL-3"
SLOT="0"

RDEPEND="dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-soundtouch:0.10"
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-python27.patch
	"${FILESDIR}"/${P}-desktop.patch
)
