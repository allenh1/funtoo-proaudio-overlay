# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion exteutils

DESCRIPTION="SLV2 is a library for LV2 hosts "
HOMEPAGE="http://drobilla.net/software"
SRC_URI="http://download.drobilla.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="jack"

DEPEND=">=dev-util/pkgconfig-0.9.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.102.29 )
	>=dev-libs/rasqal-0.9.11
	>=media-libs/raptor-1.4.0
	>=sys-libs/raul-0.4.0
	media-libs/lv2core"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix pkg-config .pc
	epatch "${FILESDIR}/${PN}-pc.in.patch"
}

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}
