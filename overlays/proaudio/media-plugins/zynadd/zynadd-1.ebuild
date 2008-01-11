# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="synth engines from ZynAddSubFX packed in LV2 plugin format"
HOMEPAGE="http://home.gna.org/zyn"
SRC_URI="http://download.gna.org/zyn/zyn-1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/zyn-1"

IUSE=""
RDEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam1-1
	=media-sound/zynjacku-1"

DEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam1-1
	media-libs/slv2"

pkg_setup() {
	ewarn "if building fails try the following:"
	ewarn "emerge -O media-libs/slv2 =media-libs/lv2dynparam-9999"
}

src_unpack() {
	unpack ${A}
	cd ${S}
#	export WANT_AUTOMAKE="1.10"
#	./bootstrap
}

src_compile() {
	#econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	dodir /usr/lib/lv2
	LV2_PATH="${D}/usr/lib/lv2" make DESTDIR="${D}" install || die "Install failed"
#	dodoc README AUTHORS NEWS
}

pkg_postinst() {
	elog "to lauch eg. zynadd type:"
	elog "zynjacku http://home.gna.org/zyn/zynadd/0"
	elog "(zynjacku is provided by media-sound/zynjacku)"
}

