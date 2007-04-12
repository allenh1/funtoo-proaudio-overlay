# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="LADSPA to VST bridge"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=8"
ESVN_REPO_URI="svn://jacklab.net/eXT2/ladspa2vst"

LICENSE="LGPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/vst-sdk"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_fetch
	cp /usr/include/vst/* ${S}/vst/
}

src_compile() {
	./compile || die "compilation failed"
}

src_install() {
	dodir /usr/lib/vst
	exeinto /usr/lib/vst
	doexe plugins/*.so
	dodoc readme.txt
}
