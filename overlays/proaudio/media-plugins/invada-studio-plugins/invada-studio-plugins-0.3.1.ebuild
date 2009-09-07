# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#Thanks to ssuominen for his assistance with the creation of this ebuild
EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Invada ladspa package, contains: Compressor, Filters, Reverb, Input Processor, Tube Simulator"
HOMEPAGE="http://www.invadarecords.com/Downloads.php?ID=00000263"
SRC_URI="http://www.invadarecords.com/downloads/${PN}_${PV}-1.tar.gz"
LICENSE="GPL-2"

SLOT=0
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-libs/ladspa-sdk-1.13"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/0.3.1-ladspa.patch
}

src_compile() {
	tc-export AR CC
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc dodoc COPYING CREDITS README
}
