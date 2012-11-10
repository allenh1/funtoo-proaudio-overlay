# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils exteutils
RESTRICT="mirror"
DESCRIPTION="GLASHCtl is a simple applet for controlling the LASH Audio Session Handler"
HOMEPAGE="http://dino.nongnu.org/glashctl"
SRC_URI="http://download.savannah.nongnu.org/releases/dino/${P}.tar.bz2"

LICENSE="GPL-2"
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
	epatch ${FILESDIR}/glashctl-0.4.4_configure.patch
	use wmaker || \
	sed -i -e 's@PROGRAMS = glashctl wmglashctl@PROGRAMS = glashctl@' \
		Makefile
}

src_compile(){
	# those break ar, crappy build system
	unset LDFLAGS
	econf \
		--CFLAGS="${CFLAGS}" \
		|| die "econf failed"
	# those break ar ...
	#	--LDFLAGS="${LDFLAGS}" \
	emake -j1 || die "emake failed"
}

src_install(){
	# damnit, really
	#make DESTDIR="${D}" install || die "install failed"
	dobin glashctl
	use wmaker && dobin wmglashctl
	insinto /usr/share/${PN}
	doins *.xpm *.png
	dodoc README AUTHORS ChangeLog
	insinto /usr/share/icons
	newins lash_96px.png glashctl.png
	make_desktop_entry "${PN}" GLASHCtl "${PN}" "AudioVideo;Audio;Engineering"
}
