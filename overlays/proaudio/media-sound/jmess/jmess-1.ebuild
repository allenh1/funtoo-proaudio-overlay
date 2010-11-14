# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4-r2

MY_P=${P/-/.}

DESCRIPTION="JMess can save/load an XML file with all the current jack connections"
HOMEPAGE="https://ccrma.stanford.edu/groups/soundwire/software/jmess/"
SRC_URI="https://ccrma.stanford.edu/groups/soundwire/software/${PN}/download/${MY_P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="media-sound/jack-audio-connection-kit
	x11-libs/qt-core"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"
DOCSDIR="${WORKDIR}/${MY_P}"
DOCS="INSTALL.txt TODO.txt"

src_prepare() {
	# a missing include with gcc4.4
	sed -i -e "/^#include/ i#include <cstring>" anyoption.cpp \
		|| die "sed of anyoption.cpp failed"

	# command name of qmake in the 'm' script differs
	sed -i -e "s|qmake-qt4|qmake|g" m || die "sed of m script failed"

	# execute the m script to create the pro file
	./m || die "./m failed"

	# the generated pro file is broken :-/
	cat >> jmess.pro <<- EOF
	QT += xml
	LIBS += -ljack -lpthread -lrt
	target.path = /usr/bin
	INSTALLS += target
	EOF

	qt4-r2_src_prepare
}
