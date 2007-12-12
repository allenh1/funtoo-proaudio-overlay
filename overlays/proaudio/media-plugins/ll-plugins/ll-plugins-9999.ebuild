# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="collection of LV2 plugins, LV2 extension definitions, and LV2 related tools"
HOMEPAGE="http://ll-plugins.nongnu.org"
SRC_URI=""

ECVS_SERVER="cvs.savannah.nongnu.org:/sources/ll-plugins"
ECVS_MODULE="ll-plugins"

LICENSE="gpl2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.102.27
	>=dev-cpp/gtkmm-2.8.8
	>=dev-cpp/cairomm-0.6.0
	>=media-sound/lash-0.5.1
	>=media-libs/liblo-0.22
	>=sci-libs/gsl-1.8
	>=media-libs/libsndfile-1.0.16
	>=media-libs/slv2-0.3.2"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack(){
	cvs_src_unpack
	cd ${S}
	# find slv2!
	epatch "${FILESDIR}/${PN}-vs-slv2.patch"
}

src_compile(){
	./configure \
		--prefix=/usr \
		--CFLAGS="${CFLAGS} `pkg-config --cflags slv2`" \
		--LDFLAGS="${LDFLAGS} `pkg-config --libs slv2`" \
		|| die "configure failed"
	emake || die "make failed"
}

src_install(){
	make DESTDIR="${D}" install || die "install failed"
}
