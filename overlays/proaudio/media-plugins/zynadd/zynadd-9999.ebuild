# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="synth engines from ZynAddSubFX and pack them in LV2 plugin format"
HOMEPAGE="http://home.gna.org/zyn"

ESVN_REPO_URI="http://svn.gna.org/svn/zyn/code"
ESVN_PROJECT="zyn"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"

S="${WORKDIR}/${PN}"

IUSE=""
RDEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam-9999
	=media-sound/zynjacku-9999"

DEPEND="=sci-libs/fftw-3*
	=media-libs/lv2dynparam-9999
	media-libs/slv2"

src_unpack() {
	subversion_src_unpack ${A}
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

