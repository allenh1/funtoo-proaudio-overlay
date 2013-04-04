# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

DESCRIPTION="Yet Another Time Machine: simple command line audio player which
can perform time-stretched playback"
HOMEPAGE="http://delysid.org/yatm.html"
SRC_URI="http://delysid.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="media-libs/libao
	media-libs/libmad
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/speex
	sys-libs/slang"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(AUTHORS ChangeLog NEWS README)
