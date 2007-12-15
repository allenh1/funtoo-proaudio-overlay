# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde subversion

DESCRIPTION="KDE based fork of the great Envy24control mixer"
HOMEPAGE="http://kenvy24.wiki.sourceforge.net/"

ESVN_REPO_URI="http://kenvy24.svn.sourceforge.net/svnroot/kenvy24/kenvy24gui/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/alsa-lib"
RDEPEND="${DEPEND}"

need-kde 3.5
