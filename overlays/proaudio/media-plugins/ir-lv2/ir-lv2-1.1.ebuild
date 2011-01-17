# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_PN="ir.lv2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="IR is a zero-latency, realtime, high performance signal convolver
especially for creating reverb effects."
HOMEPAGE="http://factorial.hu/plugins/lv2/ir"
SRC_URI="http://factorial.hu/system/files/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/zita-convolver
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	# seems it was misprinted
	sed -e "s/licence/license/" -i "${S}/ir.ttl"
}

src_install() {
	emake INSTDIR="${D}/usr/$(get_libdir)/lv2/${MY_PN}" install || die
}
