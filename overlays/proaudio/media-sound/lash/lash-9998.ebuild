# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Temporary wrapper for liblas (lash) and ladish"
HOMEPAGE="http://proaudio.tuxfamily.org"
SRC_URI=""

LICENSE=""
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="ladish"

RDEPEND="ladish? ( media-sound/ladish )
	!ladish? ( media-sound/lash-original )"
DEPEND="${RDEPEND}"
