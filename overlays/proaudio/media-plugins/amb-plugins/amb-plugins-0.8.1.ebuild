# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/amb-plugins/amb-plugins-0.4.0.ebuild,v 1.2 2009/10/02 22:54:41 maekke Exp $

inherit multilib toolchain-funcs exteutils

RESTRICT="mirror"
MY_P=${P/amb/AMB}

DESCRIPTION="AMB-plugins ladspa plugin package. Filters by Fons Adriaensen"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fixup the Makefile
	esed_check -i -e 's@g++@\$(CXX) \$(LDFLAGS)@g' -e '/^CPPFLAGS/ s/-O3//' Makefile
}

src_compile() {
	tc-export CXX
	emake || die
}

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
