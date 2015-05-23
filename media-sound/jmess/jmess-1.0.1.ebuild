# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit qt4-r2

DESCRIPTION="JMess can save/load an XML file with all the current jack connections"
HOMEPAGE="https://ccrma.stanford.edu/groups/soundwire/software/jmess/"
SRC_URI="http://jmess-jack.googlecode.com/files/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="media-sound/jack-audio-connection-kit
	dev-qt/qtcore"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

DOCS=("${WORKDIR}/${P}/INSTALL.txt" "${WORKDIR}/${P}/TODO.txt")
