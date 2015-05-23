# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit python-r1

DESCRIPTION="Simple OSC (Open Sound Control) client code for Python"
HOMEPAGE="https://github.com/kaoskorobase/PyOSC"
# zip snapshot straight from github, renamed and uploaded to proaudio distfiles
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	!<=media-sound/khagan-0.1.2-r1
	!<=media-sound/fastbreeder-1.0.1-r1"

S=${WORKDIR}/${PN}-master
RESTRICT="mirror"

src_install() {
	install_pyosc() {
		python_domodule OSC.py

		# upstream names file OSC.py but media-sound/{khagan,fastbreeder}
		# want file named osc.py
		dosym "$(python_get_sitedir)"/OSC.py "$(python_get_sitedir)"/osc.py
}

	python_foreach_impl install_pyosc
}
