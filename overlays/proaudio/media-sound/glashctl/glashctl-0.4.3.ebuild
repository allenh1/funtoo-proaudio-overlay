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
IUSE="wmaker"

DEPEND=">=media-sound/lash-0.5.1
	>=dev-cpp/gtkmm-2.10.1
	media-sound/jack-audio-connection-kit"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use wmaker || \
	sed -i -e 's@PROGRAMS = glashctl wmglashctl@PROGRAMS = glashctl@' \
		Makefile
}

src_compile(){
	# those break ar, crappy build system
	unset LDFLAGS
	econf \
		--prefix=/usr \
		--CFLAGS="${CFLAGS}" \
		|| die "econf failed"
	# those break ar ...
	#	--LDFLAGS="${LDFLAGS}" \
	emake || die "emake failed"
}

src_install(){
	# damnit, really
	#make DESTDIR="${D}" install || die "install failed"
	dobin glashctl
	use wmaker && dobin wmglashctl
	insinto /usr/share/${PN}
	doins *.xpm *.png
	dodoc README AUTHORS ChangeLog	
}
