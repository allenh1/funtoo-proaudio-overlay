# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils
RESTRICT="nomirror"
DESCRIPTION="GLASHCtl is a simple applet for controlling the LASH Audio Session Handler"
HOMEPAGE="http://dino.nongnu.org/glashctl"
SRC_URI="http://download.savannah.nongnu.org/releases/dino/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-sound/lash-0.5.1
	>=x11-libs/vte-0.11.15
	>=dev-cpp/gtkmm-2.10.1"
RDEPEND=""

src_unpack() {
	unpack "${A}"
	cd "${S}"
	esed_check -i -e 's:ar rcs $$@ $$^ $(LDFLAGS) $$($(2)_LDFLAGS):ar rcs $$@ $$^ $($(2)_LDFLAGS):g' \
		Makefile.template 
}

src_compile(){
	econf --prefix="${D}"/usr || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	einstall || die "einstall failed"
	prepalldocs
}
