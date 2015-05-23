# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit

DESCRIPTION="SilentJack is a silence/dead air detector for the Jack Audio Connection Kit"
HOMEPAGE="http://www.aelius.com/njh/silentjack"
SRC_URI="http://www.aelius.com/njh/silentjack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
