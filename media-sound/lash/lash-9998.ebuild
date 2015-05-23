# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Temporary wrapper for liblash (lash) and ladish"
HOMEPAGE="http://proaudio.tuxfamily.org/"
SRC_URI=""

# A license is needed. Both LASH and LADISH are licensed under the GPL-2.
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="ladish"

RDEPEND="ladish? ( media-sound/ladish
		!media-sound/lash-original )
	!ladish? ( media-sound/lash-original
		!media-sound/ladish )"
DEPEND="${RDEPEND}"
