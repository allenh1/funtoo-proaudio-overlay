# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit kde
#need-qt 3
#need-kde 3

# TODO: this ebuild needs some kde/qt3 eclass work -- will not function

DESCRIPTION="tuneroid is a tuner for variety of musical instruments"
HOMEPAGE="http://zyzstar.kosoru.com/?tuneroid"
SRC_URI="http://zyzstar.kosoru.com/projects/tuneroid/downloads/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=">=media-libs/alsa-lib-0.9"

