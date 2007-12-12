# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

DESCRIPTION="SLV2 is a library for LV2 hosts"
HOMEPAGE="http://wiki.drobilla.net/SLV2"
SRC_URI="http://download.drobilla.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="jack"
	
DEPEND=">=dev-util/pkgconfig-0.9.0
		jack? ( >=media-sound/jack-audio-connection-kit-0.102.29 )
		dev-libs/redland"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix pkg-config .pc
	epatch "${FILESDIR}/${PN}-pc.in.patch"
}

src_compile() {
	econf `use_enable jack` || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc README AUTHORS
}

