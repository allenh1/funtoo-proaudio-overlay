# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Tool for storing/restoring jack connections states."
HOMEPAGE="http://sourceforge.net/projects/heaven/"
SRC_URI="mirror://sourceforge/heaven/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND="$DEPEND"

PREFIX="${D}"/usr

src_prepare() {
	sed -i -e 's/$(CXX)/$(CXX) $(CXXFLAGS)/' Makefile || die "sed Makefile failed"
	sed -i -e '/^install:/ a\
	mkdir -p $(PREFIX)/bin' Makefile || die "sed2 Makefile failed"
}

src_configure() {
	echo "nothing to configure" || die "econf failed"
}

src_compile() {
	emake jack_snapshot || die "emake failed"
}

src_install() {
#	mkdir -p "${D}"/bin || die "mkdir failed"
	emake PREFIX="${PREFIX}" install || die "stop"
	dodoc README TODO || die
}
