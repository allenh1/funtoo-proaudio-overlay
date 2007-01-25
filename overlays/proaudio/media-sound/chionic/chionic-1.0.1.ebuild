# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions eutils scons-ccache

DESCRIPTION="advanced sampler for linux"
HOMEPAGE="http://www.reduz.com.ar/chionic"
SRC_URI="mirror://sourceforge/cheesetronic/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

DEPEND="alsa? ( >=media-libs/alsa-lib-0.9 )
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
		>=dev-util/scons-0.9
		>=media-libs/libsndfile-1.0.0
		>=media-libs/ladspa-sdk-1.12"
RDEPEND=">=dev-lang/python-2.4
		dev-util/pkgconfig"

need-qt 3

src_unpack(){
	unpack ${A}
	cd ${S}	
	epatch $FILESDIR/gcc4.1-fix.patch
	add_ccache_to_scons_v2
}

src_compile() {
	scons prefix=/usr || die "compile failed"
}

src_install() {
	scons install prefix=${D}/usr || die "install failed"
	rm -f "${D}/usr/bin/.sconsign"
	dodoc ChangeLog AUTHORS NEWS TODO
}
