# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="LV2 dynparam extension"
HOMEPAGE="http://home.gna.org/lv2dynparam/"

ESVN_REPO_URI="http://svn.gna.org/svn/lv2dynparam/code"
ESVN_PROJECT="lv2dynparam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"

S="${WORKDIR}/${PN}"

IUSE=""
DEPEND=""

src_unpack() {
	subversion_src_unpack ${A}
	cd ${S}
	export WANT_AUTOMAKE="1.10"
	export WANT_AUTOCONF="2.61"
	./bootstrap
}

src_compile() {
	econf || die "Configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS
}
