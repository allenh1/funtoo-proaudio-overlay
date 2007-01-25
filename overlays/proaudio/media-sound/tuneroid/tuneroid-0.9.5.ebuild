# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde
need-qt 3
need-kde 3

DESCRIPTION="tuneroid is a tuner for variety of musical instruments"
HOMEPAGE="http://zyzstar.kosoru.com/?tuneroid"
SRC_URI="http://zyzstar.kosoru.com/projects/tuneroid/downloads/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/alsa-lib-0.9"

