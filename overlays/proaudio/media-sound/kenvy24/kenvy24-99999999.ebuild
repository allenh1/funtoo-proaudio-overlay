# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
# po/ directory is disabled in CMakeLists.txt
# KDE_LINGUAS="es fr pl ro"
inherit kde4-base

DESCRIPTION="VIA Envy24 based sound card control utility for KDE"
HOMEPAGE="http://kenvy24.wiki.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="https://kenvy24.svn.sourceforge.net/svnroot/kenvy24/kenvy24gui/trunk"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS=""
IUSE="debug +handbook"

DEPEND="
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

S=${WORKDIR}/${P}-src
