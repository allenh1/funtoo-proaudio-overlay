# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit multilib toolchain-funcs

MY_P=${P/ste/STE}

DESCRIPTION="STE LADSPA plugins package. Includes stereo panner and width adjuster."
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	tc-export CXX
	sed -i Makefile -e 's/-O2//' -e 's/g++/$(CXX) $(LDFLAGS)/' || die "sed Makefile"
}

src_install() {
	dodoc AUTHORS
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
