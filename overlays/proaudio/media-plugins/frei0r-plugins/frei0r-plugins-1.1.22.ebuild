# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://code.dyne.org/frei0r.git"
	inherit autotools git
	SRC_URI=""
else
	SRC_URI="http://propirate.net/frei0r/${P}.tar.gz"
fi

RESTRICT="mirror"
DESCRIPTION="Minimalistic plugin API for video effects"
HOMEPAGE="http://www.piksel.org/frei0r"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
		cd "${S}"
		eautoreconf
	else
		unpack ${A}
	fi
}

src_install(){
	emake DESTDIR="${D}" install || die "Install failed"
}
