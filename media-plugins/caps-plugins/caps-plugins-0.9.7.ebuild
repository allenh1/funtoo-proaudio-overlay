# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/caps-plugins/caps-plugins-0.4.5-r1.ebuild,v 1.1 2012/11/27 00:04:49 aballier Exp $

EAPI=4

inherit eutils toolchain-funcs multilib

IUSE=""
MY_P=caps-${PV}

DESCRIPTION="The CAPS Audio Plugin Suite - LADSPA plugin suite"
HOMEPAGE="http://quitte.de/dsp/caps.html"
SRC_URI="http://quitte.de/dsp/caps_${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_configure() {
	./configure.py || die
}

src_compile() {
#	emake CFLAGS="${CXXFLAGS}" _LDFLAGS="-nostartfiles ${LDFLAGS}" CC="$(tc-getCXX)" || die
	emake CFLAGS="-fPIC ${CXXFLAGS}" _LDFLAGS="-shared ${LDFLAGS}" CC="$(tc-getCXX)" PREFIX=/usr || die
}

src_install() {
	emake PREFIX=${D}/usr install || die
	dodoc README CHANGES
}
